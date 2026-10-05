package com.skillforge.controller;

import com.skillforge.dao.ServiceDAO;
import com.skillforge.dao.UserDAO;
import com.skillforge.model.Service;
import com.skillforge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String serviceIdStr = request.getParameter("serviceId");
        if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr.trim());
            Service service = serviceDAO.getById(serviceId);

            if (service == null || !"ACTIVE".equalsIgnoreCase(service.getStatus())) {
                request.setAttribute("errorMessage", "The requested service is no longer available.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            User freelancer = userDAO.findById(service.getFreelancerId());
            if (freelancer == null || freelancer.isBlocked()) {
                request.setAttribute("errorMessage", "The freelancer for this service is currently unavailable.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("service", service);
            request.setAttribute("freelancer", freelancer);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }
}
