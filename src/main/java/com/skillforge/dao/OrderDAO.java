package com.skillforge.dao;

import com.skillforge.model.Order;
import com.skillforge.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class OrderDAO {

    public int createOrder(Order order) {
        String sql = "INSERT INTO skillforge_orders (client_id, freelancer_id, service_id, amount, status, requirements) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getClientId());
            ps.setInt(2, order.getFreelancerId());
            ps.setInt(3, order.getServiceId());
            ps.setBigDecimal(4, order.getAmount());
            ps.setString(5, order.getStatus() != null ? order.getStatus() : "PENDING");
            ps.setString(6, order.getRequirements());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        order.setId(orderId);
                        return orderId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Order getById(int id) {
        String sql = "SELECT o.*, c.name AS client_name, c.email AS client_email, " +
                     "f.name AS freelancer_name, f.email AS freelancer_email, " +
                     "s.title AS service_title, " +
                     "p.payment_method, p.transaction_id, " +
                     "(SELECT COUNT(*) FROM skillforge_reviews r WHERE r.order_id = o.id) AS is_reviewed " +
                     "FROM skillforge_orders o " +
                     "JOIN skillforge_users c ON o.client_id = c.id " +
                     "JOIN skillforge_users f ON o.freelancer_id = f.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "LEFT JOIN skillforge_payments p ON o.id = p.order_id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByClientId(int clientId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, c.name AS client_name, c.email AS client_email, " +
                     "f.name AS freelancer_name, f.email AS freelancer_email, " +
                     "s.title AS service_title, " +
                     "p.payment_method, p.transaction_id, " +
                     "(SELECT COUNT(*) FROM skillforge_reviews r WHERE r.order_id = o.id) AS is_reviewed " +
                     "FROM skillforge_orders o " +
                     "JOIN skillforge_users c ON o.client_id = c.id " +
                     "JOIN skillforge_users f ON o.freelancer_id = f.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "LEFT JOIN skillforge_payments p ON o.id = p.order_id " +
                     "WHERE o.client_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByFreelancerId(int freelancerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, c.name AS client_name, c.email AS client_email, " +
                     "f.name AS freelancer_name, f.email AS freelancer_email, " +
                     "s.title AS service_title, " +
                     "p.payment_method, p.transaction_id, " +
                     "(SELECT COUNT(*) FROM skillforge_reviews r WHERE r.order_id = o.id) AS is_reviewed " +
                     "FROM skillforge_orders o " +
                     "JOIN skillforge_users c ON o.client_id = c.id " +
                     "JOIN skillforge_users f ON o.freelancer_id = f.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "LEFT JOIN skillforge_payments p ON o.id = p.order_id " +
                     "WHERE o.freelancer_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, freelancerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, c.name AS client_name, c.email AS client_email, " +
                     "f.name AS freelancer_name, f.email AS freelancer_email, " +
                     "s.title AS service_title, " +
                     "p.payment_method, p.transaction_id, " +
                     "(SELECT COUNT(*) FROM skillforge_reviews r WHERE r.order_id = o.id) AS is_reviewed " +
                     "FROM skillforge_orders o " +
                     "JOIN skillforge_users c ON o.client_id = c.id " +
                     "JOIN skillforge_users f ON o.freelancer_id = f.id " +
                     "JOIN skillforge_services s ON o.service_id = s.id " +
                     "LEFT JOIN skillforge_payments p ON o.id = p.order_id " +
                     "ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql;
        if ("COMPLETED".equalsIgnoreCase(status)) {
            sql = "UPDATE skillforge_orders SET status = ?, completed_at = CURRENT_TIMESTAMP WHERE id = ?";
        } else {
            sql = "UPDATE skillforge_orders SET status = ? WHERE id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deliverOrder(int orderId, String deliveryMessage) {
        String sql = "UPDATE skillforge_orders SET status = 'DELIVERED', delivery_message = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deliveryMessage);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Object> getFreelancerStats(int freelancerId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total_orders, " +
                     "COALESCE(SUM(CASE WHEN status IN ('ACCEPTED', 'IN_PROGRESS', 'DELIVERED') THEN 1 ELSE 0 END), 0) AS active_orders, " +
                     "COALESCE(SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END), 0) AS completed_orders, " +
                     "COALESCE(SUM(CASE WHEN status = 'COMPLETED' THEN amount ELSE 0 END), 0.0) AS total_earnings, " +
                     "(SELECT COALESCE(AVG(rating), 5.0) FROM skillforge_reviews WHERE freelancer_id = ?) AS avg_rating " +
                     "FROM skillforge_orders WHERE freelancer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, freelancerId);
            ps.setInt(2, freelancerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalOrders", rs.getInt("total_orders"));
                    stats.put("activeOrders", rs.getInt("active_orders"));
                    stats.put("completedOrders", rs.getInt("completed_orders"));
                    stats.put("totalEarnings", rs.getBigDecimal("total_earnings"));
                    stats.put("avgRating", Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Object> getClientStats(int clientId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total_orders, " +
                     "COALESCE(SUM(CASE WHEN status IN ('PENDING', 'ACCEPTED', 'IN_PROGRESS', 'DELIVERED') THEN 1 ELSE 0 END), 0) AS active_orders, " +
                     "COALESCE(SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END), 0) AS completed_orders, " +
                     "COALESCE(SUM(amount), 0.0) AS total_spent " +
                     "FROM skillforge_orders WHERE client_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalOrders", rs.getInt("total_orders"));
                    stats.put("activeOrders", rs.getInt("active_orders"));
                    stats.put("completedOrders", rs.getInt("completed_orders"));
                    stats.put("totalSpent", rs.getBigDecimal("total_spent"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM skillforge_users) AS total_users, " +
                     "(SELECT COUNT(*) FROM skillforge_users WHERE role = 'FREELANCER') AS total_freelancers, " +
                     "(SELECT COUNT(*) FROM skillforge_users WHERE role = 'CLIENT') AS total_clients, " +
                     "(SELECT COUNT(*) FROM skillforge_services WHERE status = 'ACTIVE') AS total_services, " +
                     "(SELECT COUNT(*) FROM skillforge_orders) AS total_orders, " +
                     "(SELECT COALESCE(SUM(amount), 0.0) FROM skillforge_payments WHERE status = 'COMPLETED') AS total_revenue";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("totalUsers", rs.getInt("total_users"));
                stats.put("totalFreelancers", rs.getInt("total_freelancers"));
                stats.put("totalClients", rs.getInt("total_clients"));
                stats.put("totalServices", rs.getInt("total_services"));
                stats.put("totalOrders", rs.getInt("total_orders"));
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setClientId(rs.getInt("client_id"));
        o.setClientName(rs.getString("client_name"));
        o.setClientEmail(rs.getString("client_email"));
        o.setFreelancerId(rs.getInt("freelancer_id"));
        o.setFreelancerName(rs.getString("freelancer_name"));
        o.setFreelancerEmail(rs.getString("freelancer_email"));
        o.setServiceId(rs.getInt("service_id"));
        o.setServiceTitle(rs.getString("service_title"));
        o.setAmount(rs.getBigDecimal("amount"));
        o.setStatus(rs.getString("status"));
        o.setRequirements(rs.getString("requirements"));
        o.setDeliveryMessage(rs.getString("delivery_message"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setCompletedAt(rs.getTimestamp("completed_at"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setTransactionId(rs.getString("transaction_id"));
        o.setReviewed(rs.getInt("is_reviewed") > 0);
        return o;
    }
}
