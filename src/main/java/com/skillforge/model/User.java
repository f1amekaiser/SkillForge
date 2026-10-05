package com.skillforge.model;

import java.sql.Timestamp;
import java.util.List;

public class User {
    private int id;
    private String name;
    private String username;
    private String email;
    private String passwordHash;
    private String role; // CLIENT, FREELANCER, ADMIN
    private String profileImage;
    private String bio;
    private String status; // ACTIVE, BLOCKED
    private Timestamp createdAt;
    private List<Skill> skills;

    public User() {
    }

    public User(int id, String name, String username, String email, String role, String status) {
        this.id = id;
        this.name = name;
        this.username = username;
        this.email = email;
        this.role = role;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getProfileImage() {
        return profileImage != null && !profileImage.isEmpty() ? profileImage : "default-avatar.png";
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getStatus() {
        return status != null ? status : "ACTIVE";
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<Skill> getSkills() {
        return skills;
    }

    public void setSkills(List<Skill> skills) {
        this.skills = skills;
    }

    public boolean isClient() {
        return "CLIENT".equalsIgnoreCase(role);
    }

    public boolean isFreelancer() {
        return "FREELANCER".equalsIgnoreCase(role);
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }

    public boolean isBlocked() {
        return "BLOCKED".equalsIgnoreCase(status);
    }
}
