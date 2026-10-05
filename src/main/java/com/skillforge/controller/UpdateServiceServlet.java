package com.skillforge.controller;

import com.skillforge.dao.CategoryDAO;
import com.skillforge.dao.ServiceDAO;
import com.skillforge.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/edit-service")
public class UpdateServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int freelancerId = (Integer) session.getAttribute("userId");

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/my-services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(idStr);
            Service service = serviceDAO.getById(serviceId);

            if (service == null || service.getFreelancerId() != freelancerId) {
                request.setAttribute("errorMessage", "Service not found or unauthorized.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("service", service);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/edit-service.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-services");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int freelancerId = (Integer) session.getAttribute("userId");

        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String deliveryDaysStr = request.getParameter("deliveryDays");
        String status = request.getParameter("status");

        try {
            int serviceId = Integer.parseInt(idStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            BigDecimal price = new BigDecimal(priceStr);
            int deliveryDays = Integer.parseInt(deliveryDaysStr);

            Service service = new Service();
            service.setId(serviceId);
            service.setFreelancerId(freelancerId);
            service.setCategoryId(categoryId);
            service.setTitle(title.trim());
            service.setDescription(description.trim());
            service.setPrice(price);
            service.setDeliveryDays(deliveryDays);
            service.setStatus(status != null ? status : "ACTIVE");

            boolean success = serviceDAO.updateService(service);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/my-services?msg=service_updated");
            } else {
                request.setAttribute("error", "Failed to update service.");
                request.setAttribute("service", service);
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/edit-service.jsp").forward(request, response);
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/my-services");
        }
    }
}
