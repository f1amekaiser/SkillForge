package com.skillforge.model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int orderId;
    private int clientId;
    private String clientName;
    private String clientImage;
    private int freelancerId;
    private String freelancerName;
    private int rating; // 1 to 5
    private String comment;
    private Timestamp createdAt;
    private String serviceTitle;

    public Review() {
    }

    public Review(int id, int orderId, int clientId, int freelancerId, int rating, String comment) {
        this.id = id;
        this.orderId = orderId;
        this.clientId = clientId;
        this.freelancerId = freelancerId;
        this.rating = rating;
        this.comment = comment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getClientId() {
        return clientId;
    }

    public void setClientId(int clientId) {
        this.clientId = clientId;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getClientImage() {
        return clientImage != null && !clientImage.isEmpty() ? clientImage : "default-avatar.png";
    }

    public void setClientImage(String clientImage) {
        this.clientImage = clientImage;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getServiceTitle() {
        return serviceTitle;
    }

    public void setServiceTitle(String serviceTitle) {
        this.serviceTitle = serviceTitle;
    }

    public String getStars() {
        return getStarsSvg();
    }

    public String getStarsSvg() {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                sb.append("<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"#f59e0b\" stroke=\"#f59e0b\" stroke-width=\"1\" style=\"display:inline-block; vertical-align:middle; margin-right:2px;\"><polygon points=\"12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2\"></polygon></svg>");
            } else {
                sb.append("<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"#cbd5e1\" stroke-width=\"2\" style=\"display:inline-block; vertical-align:middle; margin-right:2px;\"><polygon points=\"12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2\"></polygon></svg>");
            }
        }
        return sb.toString();
    }
}
