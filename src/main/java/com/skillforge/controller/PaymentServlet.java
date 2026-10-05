package com.skillforge.controller;

import com.google.gson.JsonObject;
import com.skillforge.dao.OrderDAO;
import com.skillforge.dao.PaymentDAO;
import com.skillforge.dao.ServiceDAO;
import com.skillforge.dao.UserDAO;
import com.skillforge.model.Order;
import com.skillforge.model.Payment;
import com.skillforge.model.Service;
import com.skillforge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Random;

@WebServlet(urlPatterns = {"/payment", "/api/verify-availability"})
public class PaymentServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // AJAX Service Availability Verification
        if ("/api/verify-availability".equals(path)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String serviceIdStr = request.getParameter("serviceId");
            JsonObject json = new JsonObject();

            if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
                json.addProperty("available", false);
                json.addProperty("message", "Service ID missing");
                response.getWriter().write(json.toString());
                return;
            }

            try {
                int serviceId = Integer.parseInt(serviceIdStr.trim());
                Service service = serviceDAO.getById(serviceId);
                if (service != null && "ACTIVE".equalsIgnoreCase(service.getStatus())) {
                    User freelancer = userDAO.findById(service.getFreelancerId());
                    if (freelancer != null && !freelancer.isBlocked()) {
                        json.addProperty("available", true);
                        json.addProperty("serviceTitle", service.getTitle());
                        json.addProperty("price", service.getPrice().doubleValue());
                        json.addProperty("freelancerName", freelancer.getName());
                        json.addProperty("message", "Service and freelancer are available for order!");
                        response.getWriter().write(json.toString());
                        return;
                    }
                }
            } catch (Exception ignored) {}

            json.addProperty("available", false);
            json.addProperty("message", "Service is currently unavailable or freelancer is offline.");
            response.getWriter().write(json.toString());
            return;
        }

        // Forward to payment page if accessed directly
        String serviceIdStr = request.getParameter("serviceId");
        if (serviceIdStr != null) {
            response.sendRedirect(request.getContextPath() + "/checkout?serviceId=" + serviceIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/services");
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

        int clientId = (Integer) session.getAttribute("userId");
        String serviceIdStr = request.getParameter("serviceId");
        String requirements = request.getParameter("requirements");
        String paymentMethod = request.getParameter("paymentMethod");

        if (serviceIdStr == null || requirements == null || requirements.trim().isEmpty() ||
            paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.setAttribute("error", "Please provide project requirements and choose a payment method.");
            response.sendRedirect(request.getContextPath() + "/checkout?serviceId=" + serviceIdStr);
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr.trim());
            Service service = serviceDAO.getById(serviceId);

            if (service == null || !"ACTIVE".equalsIgnoreCase(service.getStatus())) {
                request.setAttribute("errorMessage", "Service is no longer available.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Create Order
            Order order = new Order();
            order.setClientId(clientId);
            order.setFreelancerId(service.getFreelancerId());
            order.setServiceId(serviceId);
            order.setAmount(service.getPrice());
            order.setStatus("PENDING");
            order.setRequirements(requirements.trim());

            int orderId = orderDAO.createOrder(order);

            if (orderId > 0) {
                // Generate Mock Transaction ID
                String prefix = "UPI".equalsIgnoreCase(paymentMethod) ? "TXN_UPI_" :
                                (paymentMethod.toLowerCase().contains("card") ? "TXN_CARD_" : "TXN_OFF_");
                long randomDigits = 1000000000L + (long)(new Random().nextDouble() * 9000000000L);
                String transactionId = prefix + randomDigits;

                // Record Payment
                Payment payment = new Payment();
                payment.setOrderId(orderId);
                payment.setAmount(service.getPrice());
                payment.setPaymentMethod(paymentMethod);
                payment.setTransactionId(transactionId);
                payment.setStatus("COMPLETED");

                paymentDAO.recordPayment(payment);

                response.sendRedirect(request.getContextPath() + "/order-details?id=" + orderId + "&msg=order_success");
            } else {
                request.setAttribute("errorMessage", "Could not process order. Please try again.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }
}
