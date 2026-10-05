package com.skillforge.controller;

import com.skillforge.dao.UserDAO;
import com.skillforge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/users", "/admin/users/action"})
public class AdminUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleFilter = request.getParameter("role");
        List<User> users;

        if (roleFilter != null && !roleFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleFilter)) {
            users = userDAO.getUsersByRole(roleFilter.trim().toUpperCase());
        } else {
            users = userDAO.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("selectedRole", roleFilter != null ? roleFilter : "ALL");
        request.getRequestDispatcher("/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");
        String action = request.getParameter("action"); // "block" or "unblock"

        if (userIdStr != null && action != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                String newStatus = "block".equalsIgnoreCase(action) ? "BLOCKED" : "ACTIVE";
                userDAO.updateStatus(userId, newStatus);
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?msg=status_changed");
    }
}
