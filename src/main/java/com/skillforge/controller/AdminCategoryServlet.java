package com.skillforge.controller;

import com.skillforge.dao.CategoryDAO;
import com.skillforge.dao.PaymentDAO;
import com.skillforge.model.Category;
import com.skillforge.model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/categories", "/admin/categories/action", "/admin/payments"})
public class AdminCategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/admin/payments".equals(path)) {
            List<Payment> payments = paymentDAO.getAllPayments();
            BigDecimal totalRevenue = paymentDAO.getTotalRevenue();
            request.setAttribute("payments", payments);
            request.setAttribute("totalRevenue", totalRevenue);
            request.getRequestDispatcher("/manage-payments.jsp").forward(request, response);
        } else {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/manage-categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String icon = request.getParameter("icon");
        String idStr = request.getParameter("id");

        if ("create".equalsIgnoreCase(action)) {
            if (name != null && !name.trim().isEmpty()) {
                Category c = new Category();
                c.setName(name.trim());
                c.setDescription(description != null ? description.trim() : "");
                c.setIcon(icon != null ? icon.trim() : "briefcase");
                categoryDAO.createCategory(c);
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            if (idStr != null && name != null && !name.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Category c = new Category();
                    c.setId(id);
                    c.setName(name.trim());
                    c.setDescription(description != null ? description.trim() : "");
                    c.setIcon(icon != null ? icon.trim() : "briefcase");
                    categoryDAO.updateCategory(c);
                } catch (NumberFormatException ignored) {}
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    categoryDAO.deleteCategory(id);
                } catch (NumberFormatException ignored) {}
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories?msg=success");
    }
}
