package com.skillforge.model;

import java.sql.Timestamp;

public class Wishlist {
    private int id;
    private int clientId;
    private int serviceId;
    private Timestamp createdAt;
    private Service service;

    public Wishlist() {
    }

    public Wishlist(int id, int clientId, int serviceId, Timestamp createdAt) {
        this.id = id;
        this.clientId = clientId;
        this.serviceId = serviceId;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getClientId() {
        return clientId;
    }

    public void setClientId(int clientId) {
        this.clientId = clientId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }
}
