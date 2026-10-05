package com.skillforge.controller;

import com.skillforge.dao.*;
import com.skillforge.model.Order;
import com.skillforge.model.Service;
import com.skillforge.model.Skill;
import com.skillforge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
        "/client-dashboard",
        "/freelancer-dashboard",
        "/my-services",
        "/earnings",
        "/client-profile",
        "/freelancer-profile-edit"
})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();
    private final SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String path = request.getServletPath();

        switch (path) {
            case "/client-dashboard": {
                User user = userDAO.findById(userId);
                Map<String, Object> stats = orderDAO.getClientStats(userId);
                List<Order> recentOrders = orderDAO.getOrdersByClientId(userId);
                int wishlistCount = wishlistDAO.getWishlistCount(userId);

                request.setAttribute("user", user);
                request.setAttribute("stats", stats);
                request.setAttribute("recentOrders", recentOrders.size() > 5 ? recentOrders.subList(0, 5) : recentOrders);
                request.setAttribute("wishlistCount", wishlistCount);
                request.getRequestDispatcher("/client-dashboard.jsp").forward(request, response);
                break;
            }
            case "/freelancer-dashboard": {
                User user = userDAO.findById(userId);
                Map<String, Object> stats = orderDAO.getFreelancerStats(userId);
                List<Order> recentOrders = orderDAO.getOrdersByFreelancerId(userId);
                List<Service> services = serviceDAO.getByFreelancerId(userId);

                request.setAttribute("user", user);
                request.setAttribute("stats", stats);
                request.setAttribute("recentOrders", recentOrders.size() > 5 ? recentOrders.subList(0, 5) : recentOrders);
                request.setAttribute("services", services);
                request.getRequestDispatcher("/freelancer-dashboard.jsp").forward(request, response);
                break;
            }
            case "/my-services": {
                List<Service> services = serviceDAO.getByFreelancerId(userId);
                request.setAttribute("services", services);
                request.getRequestDispatcher("/my-services.jsp").forward(request, response);
                break;
            }
            case "/earnings": {
                Map<String, Object> stats = orderDAO.getFreelancerStats(userId);
                List<Order> orders = orderDAO.getOrdersByFreelancerId(userId);
                List<Order> completedOrders = new ArrayList<>();
                for (Order o : orders) {
                    if ("COMPLETED".equalsIgnoreCase(o.getStatus())) {
                        completedOrders.add(o);
                    }
                }
                request.setAttribute("stats", stats);
                request.setAttribute("completedOrders", completedOrders);
                request.getRequestDispatcher("/earnings.jsp").forward(request, response);
                break;
            }
            case "/client-profile": {
                User user = userDAO.findById(userId);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/client-profile.jsp").forward(request, response);
                break;
            }
            case "/freelancer-profile-edit": {
                User user = userDAO.findById(userId);
                List<Skill> allSkills = skillDAO.getAllSkills();
                List<Skill> userSkills = userDAO.getFreelancerSkills(userId);

                request.setAttribute("user", user);
                request.setAttribute("allSkills", allSkills);
                request.setAttribute("userSkills", userSkills);
                request.getRequestDispatcher("/freelancer-profile-edit.jsp").forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String path = request.getServletPath();

        String name = request.getParameter("name");
        String bio = request.getParameter("bio");

        User user = userDAO.findById(userId);
        if (user != null) {
            if (name != null && !name.trim().isEmpty()) {
                user.setName(name.trim());
                session.setAttribute("name", user.getName());
            }
            if (bio != null) {
                user.setBio(bio.trim());
            }
            userDAO.updateProfile(user);

            // Update skills if submitted by freelancer
            if ("/freelancer-profile-edit".equals(path)) {
                String[] selectedSkills = request.getParameterValues("skills");
                List<Integer> skillIds = new ArrayList<>();
                if (selectedSkills != null) {
                    for (String sid : selectedSkills) {
                        try {
                            skillIds.add(Integer.parseInt(sid));
                        } catch (NumberFormatException ignored) {}
                    }
                }
                userDAO.updateFreelancerSkills(userId, skillIds);
                response.sendRedirect(request.getContextPath() + "/freelancer-profile-edit?msg=profile_updated");
                return;
            }
        }

        if ("/client-profile".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/client-profile?msg=profile_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
