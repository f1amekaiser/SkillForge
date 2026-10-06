package com.skillforge.dao;

import com.skillforge.model.Skill;
import com.skillforge.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SkillDAO {

    public List<Skill> getAllSkills() {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM skillforge_skills s " +
                     "JOIN skillforge_categories c ON s.category_id = c.id ORDER BY s.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Skill s = new Skill();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setCategoryName(rs.getString("category_name"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Skill> getSkillsByCategoryId(int categoryId) {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM skillforge_skills s " +
                     "JOIN skillforge_categories c ON s.category_id = c.id WHERE s.category_id = ? ORDER BY s.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Skill s = new Skill();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setCategoryName(rs.getString("category_name"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
