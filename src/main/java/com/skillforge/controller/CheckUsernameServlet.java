package com.skillforge.controller;

import com.google.gson.JsonObject;
import com.skillforge.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/api/check-username")
public class CheckUsernameServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        JsonObject json = new JsonObject();

        if (username == null || username.trim().isEmpty()) {
            json.addProperty("available", false);
            json.addProperty("message", "Username cannot be empty");
            response.getWriter().write(json.toString());
            return;
        }

        username = username.trim();

        if (username.length() < 3) {
            json.addProperty("available", false);
            json.addProperty("message", "Username must be at least 3 characters");
            response.getWriter().write(json.toString());
            return;
        }

        boolean exists = userDAO.existsByUsername(username);

        if (exists) {
            json.addProperty("available", false);
            json.addProperty("message", "✕ Username already exists");
        } else {
            json.addProperty("available", true);
            json.addProperty("message", "✓ Username available");
        }

        response.getWriter().write(json.toString());
    }
}
