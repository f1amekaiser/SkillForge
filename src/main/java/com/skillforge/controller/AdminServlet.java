package com.skillforge.controller;

import com.skillforge.dao.*;
import com.skillforge.model.Order;
import com.skillforge.model.Service;
import com.skillforge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin-dashboard")
public class AdminServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, Object> stats = orderDAO.getAdminStats();
        List<Order> recentOrders = orderDAO.getAllOrders();
        List<User> recentUsers = userDAO.getAllUsers();
        List<Service> popularServices = serviceDAO.getFeaturedServices(6);

        request.setAttribute("stats", stats);
        request.setAttribute("recentOrders", recentOrders.size() > 5 ? recentOrders.subList(0, 5) : recentOrders);
        request.setAttribute("recentUsers", recentUsers.size() > 5 ? recentUsers.subList(0, 5) : recentUsers);
        request.setAttribute("popularServices", popularServices);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
