package com.skillforge.dao;

import com.skillforge.model.Service;
import com.skillforge.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public boolean addToWishlist(int clientId, int serviceId) {
        String sql = "INSERT INTO skillforge_wishlist (client_id, service_id) VALUES (?, ?) " +
                     "ON CONFLICT (client_id, service_id) DO NOTHING";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromWishlist(int clientId, int serviceId) {
        String sql = "DELETE FROM skillforge_wishlist WHERE client_id = ? AND service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleWishlist(int clientId, int serviceId) {
        if (isInWishlist(clientId, serviceId)) {
            removeFromWishlist(clientId, serviceId);
            return false;
        } else {
            addToWishlist(clientId, serviceId);
            return true;
        }
    }

    public boolean isInWishlist(int clientId, int serviceId) {
        String sql = "SELECT 1 FROM skillforge_wishlist WHERE client_id = ? AND service_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Service> getWishlistByClientId(int clientId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS freelancer_name, u.username AS freelancer_username, " +
                     "u.profile_image AS freelancer_image, c.name AS category_name " +
                     "FROM skillforge_wishlist w " +
                     "JOIN skillforge_services s ON w.service_id = s.id " +
                     "JOIN skillforge_users u ON s.freelancer_id = u.id " +
                     "JOIN skillforge_categories c ON s.category_id = c.id " +
                     "WHERE w.client_id = ? ORDER BY w.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                UserDAO userDAO = new UserDAO();
                while (rs.next()) {
                    Service s = new Service();
                    s.setId(rs.getInt("id"));
                    s.setFreelancerId(rs.getInt("freelancer_id"));
                    s.setFreelancerName(rs.getString("freelancer_name"));
                    s.setFreelancerUsername(rs.getString("freelancer_username"));
                    s.setFreelancerImage(rs.getString("freelancer_image"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setCategoryName(rs.getString("category_name"));
                    s.setTitle(rs.getString("title"));
                    s.setDescription(rs.getString("description"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDeliveryDays(rs.getInt("delivery_days"));
                    s.setRating(rs.getDouble("rating"));
                    s.setReviewCount(rs.getInt("review_count"));
                    s.setStatus(rs.getString("status"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    s.setSkills(userDAO.getFreelancerSkills(s.getFreelancerId()));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getWishlistCount(int clientId) {
        String sql = "SELECT COUNT(*) FROM skillforge_wishlist WHERE client_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
