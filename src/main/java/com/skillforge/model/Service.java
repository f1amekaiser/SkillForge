package com.skillforge.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Service {
    private int id;
    private int freelancerId;
    private String freelancerName;
    private String freelancerUsername;
    private String freelancerImage;
    private int categoryId;
    private String categoryName;
    private String title;
    private String description;
    private BigDecimal price;
    private int deliveryDays;
    private double rating;
    private int reviewCount;
    private String status; // ACTIVE, INACTIVE, REMOVED
    private Timestamp createdAt;
    private List<Skill> skills;

    public Service() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFreelancerId() {
        return freelancerId;
    }

    public void setFreelancerId(int freelancerId) {
        this.freelancerId = freelancerId;
    }

    public String getFreelancerName() {
        return freelancerName;
    }

    public void setFreelancerName(String freelancerName) {
        this.freelancerName = freelancerName;
    }

    public String getFreelancerUsername() {
        return freelancerUsername;
    }

    public void setFreelancerUsername(String freelancerUsername) {
        this.freelancerUsername = freelancerUsername;
    }

    public String getFreelancerImage() {
        return freelancerImage != null && !freelancerImage.isEmpty() ? freelancerImage : "default-avatar.png";
    }

    public void setFreelancerImage(String freelancerImage) {
        this.freelancerImage = freelancerImage;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDeliveryDays() {
        return deliveryDays;
    }

    public void setDeliveryDays(int deliveryDays) {
        this.deliveryDays = deliveryDays;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
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

    public String getFormattedPrice() {
        if (price == null) return "0.00";
        return String.format("₹%,.2f", price);
    }
}
