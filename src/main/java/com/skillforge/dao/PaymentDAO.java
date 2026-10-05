package com.skillforge.dao;

import com.skillforge.model.Payment;
import com.skillforge.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean recordPayment(Payment payment) {
        String sql = "INSERT INTO payments (order_id, amount, payment_method, transaction_id, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getOrderId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getTransactionId());
            ps.setString(5, payment.getStatus() != null ? payment.getStatus() : "COMPLETED");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) payment.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Payment getByOrderId(int orderId) {
        String sql = "SELECT p.*, c.name AS client_name, s.title AS service_title " +
                     "FROM payments p " +
                     "JOIN orders o ON p.order_id = o.id " +
                     "JOIN users c ON o.client_id = c.id " +
                     "JOIN services s ON o.service_id = s.id " +
                     "WHERE p.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS client_name, s.title AS service_title " +
                     "FROM payments p " +
                     "JOIN orders o ON p.order_id = o.id " +
                     "JOIN users c ON o.client_id = c.id " +
                     "JOIN services s ON o.service_id = s.id " +
                     "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0.0) FROM payments WHERE status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setOrderId(rs.getInt("order_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setStatus(rs.getString("status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        p.setClientName(rs.getString("client_name"));
        p.setServiceTitle(rs.getString("service_title"));
        return p;
    }
}
