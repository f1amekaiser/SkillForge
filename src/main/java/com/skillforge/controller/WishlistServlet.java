package com.skillforge.controller;

import com.google.gson.JsonObject;
import com.skillforge.dao.WishlistDAO;
import com.skillforge.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/wishlist", "/api/wishlist/toggle"})
public class WishlistServlet extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int clientId = (Integer) session.getAttribute("userId");
        List<Service> wishlistItems = wishlistDAO.getWishlistByClientId(clientId);

        request.setAttribute("wishlistItems", wishlistItems);
        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            if ("/api/wishlist/toggle".equals(request.getServletPath())) {
                response.setContentType("application/json");
                JsonObject json = new JsonObject();
                json.addProperty("success", false);
                json.addProperty("message", "Login required");
                response.getWriter().write(json.toString());
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        }

        int clientId = (Integer) session.getAttribute("userId");
        String serviceIdStr = request.getParameter("serviceId");

        if (serviceIdStr != null) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr.trim());
                boolean inWishlist = wishlistDAO.toggleWishlist(clientId, serviceId);
                int count = wishlistDAO.getWishlistCount(clientId);

                if ("/api/wishlist/toggle".equals(request.getServletPath())) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    JsonObject json = new JsonObject();
                    json.addProperty("success", true);
                    json.addProperty("inWishlist", inWishlist);
                    json.addProperty("count", count);
                    response.getWriter().write(json.toString());
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/wishlist");
    }
}
