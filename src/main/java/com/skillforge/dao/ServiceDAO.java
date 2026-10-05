package com.skillforge.dao;

import com.skillforge.model.Service;
import com.skillforge.model.User;
import com.skillforge.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public Service getById(int id) {
        String sql = "SELECT s.*, u.name AS freelancer_name, u.username AS freelancer_username, " +
                     "u.profile_image AS freelancer_image, c.name AS category_name " +
                     "FROM services s " +
                     "JOIN users u ON s.freelancer_id = u.id " +
                     "JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = mapResultSetToService(rs);
                    UserDAO userDAO = new UserDAO();
                    s.setSkills(userDAO.getFreelancerSkills(s.getFreelancerId()));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Service> getFeaturedServices(int limit) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.id, s.freelancer_id, s.category_id, s.title, s.description, s.price, " +
                     "s.delivery_days, s.rating, s.review_count, s.status, s.created_at, " +
                     "u.name AS freelancer_name, u.username AS freelancer_username, " +
                     "u.profile_image AS freelancer_image, c.name AS category_name " +
                     "FROM (" +
                     "    SELECT *, ROW_NUMBER() OVER (PARTITION BY freelancer_id ORDER BY rating DESC, review_count DESC, id DESC) as rn " +
                     "    FROM services " +
                     "    WHERE status = 'ACTIVE'" +
                     ") s " +
                     "JOIN users u ON s.freelancer_id = u.id " +
                     "JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.rn = 1 AND u.status = 'ACTIVE' AND u.role = 'FREELANCER' " +
                     "ORDER BY s.rating DESC, s.review_count DESC, s.id DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                UserDAO userDAO = new UserDAO();
                while (rs.next()) {
                    Service s = mapResultSetToService(rs);
                    s.setSkills(userDAO.getFreelancerSkills(s.getFreelancerId()));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Service> getByFreelancerId(int freelancerId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS freelancer_name, u.username AS freelancer_username, " +
                     "u.profile_image AS freelancer_image, c.name AS category_name " +
                     "FROM services s " +
                     "JOIN users u ON s.freelancer_id = u.id " +
                     "JOIN categories c ON s.category_id = c.id " +
                     "WHERE s.freelancer_id = ? AND s.status != 'REMOVED' " +
                     "ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, freelancerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, u.name AS freelancer_name, u.username AS freelancer_username, " +
                     "u.profile_image AS freelancer_image, c.name AS category_name " +
                     "FROM services s " +
                     "JOIN users u ON s.freelancer_id = u.id " +
                     "JOIN categories c ON s.category_id = c.id " +
                     "ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Service> searchAndFilterServices(String query, Integer categoryId,
                                                Double minPrice, Double maxPrice,
                                                Double minRating, Integer maxDeliveryDays,
                                                String sortBy) {
        List<Service> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.*, u.name AS freelancer_name, u.username AS freelancer_username, " +
            "u.profile_image AS freelancer_image, c.name AS category_name " +
            "FROM services s " +
            "JOIN users u ON s.freelancer_id = u.id " +
            "JOIN categories c ON s.category_id = c.id " +
            "WHERE s.status = 'ACTIVE' AND u.status = 'ACTIVE' "
        );

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(s.title) LIKE ? OR LOWER(s.description) LIKE ? OR LOWER(u.name) LIKE ? OR LOWER(c.name) LIKE ?) ");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND s.category_id = ? ");
            params.add(categoryId);
        }

        if (minPrice != null && minPrice > 0) {
            sql.append("AND s.price >= ? ");
            params.add(BigDecimal.valueOf(minPrice));
        }

        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND s.price <= ? ");
            params.add(BigDecimal.valueOf(maxPrice));
        }

        if (minRating != null && minRating > 0) {
            sql.append("AND s.rating >= ? ");
            params.add(minRating);
        }

        if (maxDeliveryDays != null && maxDeliveryDays > 0) {
            sql.append("AND s.delivery_days <= ? ");
            params.add(maxDeliveryDays);
        }

        // Sorting
        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.price ASC ");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.price DESC ");
        } else if ("rating".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.rating DESC, s.review_count DESC ");
        } else if ("newest".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.id DESC ");
        } else {
            // Default: relevance / popularity
            sql.append("ORDER BY s.rating DESC, s.review_count DESC, s.id DESC ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                UserDAO userDAO = new UserDAO();
                while (rs.next()) {
                    Service s = mapResultSetToService(rs);
                    s.setSkills(userDAO.getFreelancerSkills(s.getFreelancerId()));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createService(Service service) {
        String sql = "INSERT INTO services (freelancer_id, category_id, title, description, price, delivery_days, status) VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, service.getFreelancerId());
            ps.setInt(2, service.getCategoryId());
            ps.setString(3, service.getTitle());
            ps.setString(4, service.getDescription());
            ps.setBigDecimal(5, service.getPrice());
            ps.setInt(6, service.getDeliveryDays());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) service.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE services SET category_id = ?, title = ?, description = ?, price = ?, delivery_days = ?, status = ? WHERE id = ? AND freelancer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, service.getCategoryId());
            ps.setString(2, service.getTitle());
            ps.setString(3, service.getDescription());
            ps.setBigDecimal(4, service.getPrice());
            ps.setInt(5, service.getDeliveryDays());
            ps.setString(6, service.getStatus());
            ps.setInt(7, service.getId());
            ps.setInt(8, service.getFreelancerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteService(int id) {
        String sql = "UPDATE services SET status = 'REMOVED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRatingAndReviewCount(int serviceId) {
        String sql = "UPDATE services s " +
                     "SET s.rating = COALESCE((SELECT AVG(r.rating) FROM reviews r JOIN orders o ON r.order_id = o.id WHERE o.service_id = s.id), 0.0), " +
                     "    s.review_count = COALESCE((SELECT COUNT(r.id) FROM reviews r JOIN orders o ON r.order_id = o.id WHERE o.service_id = s.id), 0) " +
                     "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countServices() {
        String sql = "SELECT COUNT(*) FROM services WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Service mapResultSetToService(ResultSet rs) throws SQLException {
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
        return s;
    }
}
