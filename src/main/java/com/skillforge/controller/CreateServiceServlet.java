package com.skillforge.controller;

import com.skillforge.dao.CategoryDAO;
import com.skillforge.dao.ServiceDAO;
import com.skillforge.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/create-service")
public class CreateServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/create-service.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int freelancerId = (Integer) session.getAttribute("userId");

        String title = request.getParameter("title");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String deliveryDaysStr = request.getParameter("deliveryDays");

        if (title == null || title.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            deliveryDaysStr == null || deliveryDaysStr.trim().isEmpty()) {

            request.setAttribute("error", "Please fill in all required fields.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/create-service.jsp").forward(request, response);
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdStr.trim());
            BigDecimal price = new BigDecimal(priceStr.trim());
            int deliveryDays = Integer.parseInt(deliveryDaysStr.trim());

            if (price.compareTo(BigDecimal.ZERO) <= 0 || deliveryDays <= 0) {
                request.setAttribute("error", "Price and delivery days must be greater than zero.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/create-service.jsp").forward(request, response);
                return;
            }

            Service service = new Service();
            service.setFreelancerId(freelancerId);
            service.setCategoryId(categoryId);
            service.setTitle(title.trim());
            service.setDescription(description.trim());
            service.setPrice(price);
            service.setDeliveryDays(deliveryDays);

            boolean success = serviceDAO.createService(service);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/my-services?msg=service_created");
            } else {
                request.setAttribute("error", "Could not create service due to a database error.");
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/create-service.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid format for price or delivery days.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/create-service.jsp").forward(request, response);
        }
    }
}
