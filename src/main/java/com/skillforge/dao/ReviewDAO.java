package com.skillforge.dao;

import com.skillforge.model.Review;
import com.skillforge.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(Review review) {
        String sql = "INSERT INTO skillforge_reviews (order_id, client_id, freelancer_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, review.getOrderId());
            ps.setInt(2, review.getClientId());
            ps.setInt(3, review.getFreelancerId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) review.setId(rs.getInt(1));
                }

                // Update service rating and review count
                OrderDAO orderDAO = new OrderDAO();
                com.skillforge.model.Order order = orderDAO.getById(review.getOrderId());
                if (order != null) {
                    ServiceDAO serviceDAO = new ServiceDAO();
                    serviceDAO.updateRatingAndReviewCount(order.getServiceId());
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Review> getReviewsByFreelancerId(int freelancerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name AS client_name, c.profile_image AS client_image, " +
                     "f.name AS freelancer_name, s.title AS service_title " +
                     "FROM skillforge_reviews r " +
                     "JOIN skillforge_users c ON r.client_id = c.id " +
                     "JOIN skillforge_users f ON r.freelancer_id = f.id " +
                     "JOIN skillforge_orders o ON r.order_id = o.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "WHERE r.freelancer_id = ? ORDER BY r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, freelancerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Review> getReviewsByServiceId(int serviceId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name AS client_name, c.profile_image AS client_image, " +
                     "f.name AS freelancer_name, s.title AS service_title " +
                     "FROM skillforge_reviews r " +
                     "JOIN skillforge_users c ON r.client_id = c.id " +
                     "JOIN skillforge_users f ON r.freelancer_id = f.id " +
                     "JOIN skillforge_orders o ON r.order_id = o.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "WHERE s.id = ? ORDER BY r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Review getReviewByOrderId(int orderId) {
        String sql = "SELECT r.*, c.name AS client_name, c.profile_image AS client_image, " +
                     "f.name AS freelancer_name, s.title AS service_title " +
                     "FROM skillforge_reviews r " +
                     "JOIN skillforge_users c ON r.client_id = c.id " +
                     "JOIN skillforge_users f ON r.freelancer_id = f.id " +
                     "JOIN skillforge_orders o ON r.order_id = o.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "WHERE r.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReview(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean hasClientReviewedOrder(int orderId, int clientId) {
        String sql = "SELECT 1 FROM skillforge_reviews WHERE order_id = ? AND client_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getInt("id"));
        r.setOrderId(rs.getInt("order_id"));
        r.setClientId(rs.getInt("client_id"));
        r.setClientName(rs.getString("client_name"));
        r.setClientImage(rs.getString("client_image"));
        r.setFreelancerId(rs.getInt("freelancer_id"));
        r.setFreelancerName(rs.getString("freelancer_name"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setServiceTitle(rs.getString("service_title"));
        return r;
    }
}
