package com.skillforge.controller;

import com.skillforge.dao.OrderDAO;
import com.skillforge.dao.PaymentDAO;
import com.skillforge.dao.ReviewDAO;
import com.skillforge.model.Order;
import com.skillforge.model.Payment;
import com.skillforge.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/my-orders", "/incoming-orders", "/order-details", "/order/action"})
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

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

        if ("/my-orders".equals(path)) {
            List<Order> orders = orderDAO.getOrdersByClientId(userId);
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
        } else if ("/incoming-orders".equals(path)) {
            List<Order> orders = orderDAO.getOrdersByFreelancerId(userId);
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/incoming-orders.jsp").forward(request, response);
        } else if ("/order-details".equals(path)) {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            try {
                int orderId = Integer.parseInt(idStr);
                Order order = orderDAO.getById(orderId);

                if (order == null) {
                    request.setAttribute("errorMessage", "Order not found.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

                // Check authorization
                if (!"ADMIN".equalsIgnoreCase(role) &&
                    order.getClientId() != userId &&
                    order.getFreelancerId() != userId) {
                    response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
                    return;
                }

                Payment payment = paymentDAO.getByOrderId(orderId);
                Review review = reviewDAO.getReviewByOrderId(orderId);

                request.setAttribute("order", order);
                request.setAttribute("payment", payment);
                request.setAttribute("review", review);
                request.getRequestDispatcher("/order-details.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/");
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
        String role = (String) session.getAttribute("role");

        String orderIdStr = request.getParameter("orderId");
        String action = request.getParameter("action");
        String deliveryMessage = request.getParameter("deliveryMessage");

        if (orderIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getById(orderId);

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            boolean isFreelancer = (order.getFreelancerId() == userId);
            boolean isClient = (order.getClientId() == userId);
            boolean isAdmin = "ADMIN".equalsIgnoreCase(role);

            if (!isFreelancer && !isClient && !isAdmin) {
                response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
                return;
            }

            switch (action.toLowerCase()) {
                case "accept":
                    if (isFreelancer || isAdmin) {
                        orderDAO.updateOrderStatus(orderId, "ACCEPTED");
                    }
                    break;

                case "start":
                    if (isFreelancer || isAdmin) {
                        orderDAO.updateOrderStatus(orderId, "IN_PROGRESS");
                    }
                    break;

                case "deliver":
                    if (isFreelancer || isAdmin) {
                        String msg = (deliveryMessage != null && !deliveryMessage.trim().isEmpty())
                                ? deliveryMessage.trim()
                                : "The project deliverables have been submitted.";
                        orderDAO.deliverOrder(orderId, msg);
                    }
                    break;

                case "complete":
                    if (isClient || isAdmin) {
                        orderDAO.updateOrderStatus(orderId, "COMPLETED");
                    }
                    break;

                case "cancel":
                    if (isClient || isFreelancer || isAdmin) {
                        orderDAO.updateOrderStatus(orderId, "CANCELLED");
                    }
                    break;
            }

            response.sendRedirect(request.getContextPath() + "/order-details?id=" + orderId + "&msg=status_updated");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
