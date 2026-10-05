package com.skillforge.controller;

import com.skillforge.dao.OrderDAO;
import com.skillforge.dao.ReviewDAO;
import com.skillforge.model.Order;
import com.skillforge.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int clientId = (Integer) session.getAttribute("userId");

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getById(orderId);

            if (order == null || order.getClientId() != clientId || !"COMPLETED".equalsIgnoreCase(order.getStatus())) {
                request.setAttribute("errorMessage", "Reviews can only be submitted for completed orders you placed.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            if (reviewDAO.hasClientReviewedOrder(orderId, clientId)) {
                response.sendRedirect(request.getContextPath() + "/order-details?id=" + orderId + "&msg=already_reviewed");
                return;
            }

            request.setAttribute("order", order);
            request.getRequestDispatcher("/review.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int clientId = (Integer) session.getAttribute("userId");

        String orderIdStr = request.getParameter("orderId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (orderIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                rating = 5;
            }

            Order order = orderDAO.getById(orderId);
            if (order == null || order.getClientId() != clientId || !"COMPLETED".equalsIgnoreCase(order.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            if (!reviewDAO.hasClientReviewedOrder(orderId, clientId)) {
                Review review = new Review();
                review.setOrderId(orderId);
                review.setClientId(clientId);
                review.setFreelancerId(order.getFreelancerId());
                review.setRating(rating);
                review.setComment(comment != null ? comment.trim() : "");

                reviewDAO.addReview(review);
            }

            response.sendRedirect(request.getContextPath() + "/order-details?id=" + orderId + "&msg=review_added");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }
}
