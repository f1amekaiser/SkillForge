package com.skillforge.controller;

import com.skillforge.dao.SkillDAO;
import com.skillforge.dao.UserDAO;
import com.skillforge.model.User;
import com.skillforge.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("availableSkills", skillDAO.getAllSkills());
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String bio = request.getParameter("bio");
        String[] selectedSkills = request.getParameterValues("skills");

        // Server-side validation
        if (name == null || name.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {

            request.setAttribute("error", "All mandatory fields must be filled.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Please enter a valid email address.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsByUsername(username)) {
            request.setAttribute("error", "Username already exists. Please pick another.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsByEmail(email)) {
            request.setAttribute("error", "Email is already registered. Please login.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create new user
        User user = new User();
        user.setName(name.trim());
        user.setUsername(username.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setRole("FREELANCER".equalsIgnoreCase(role) ? "FREELANCER" : "CLIENT");
        user.setBio(bio != null ? bio.trim() : "");
        user.setProfileImage("default-avatar.png");
        user.setStatus("ACTIVE");

        boolean success = userDAO.register(user);

        if (success) {
            // Save skills if freelancer
            if (user.isFreelancer() && selectedSkills != null && selectedSkills.length > 0) {
                List<Integer> skillIds = new ArrayList<>();
                for (String sid : selectedSkills) {
                    try {
                        skillIds.add(Integer.parseInt(sid));
                    } catch (NumberFormatException ignored) {}
                }
                userDAO.updateFreelancerSkills(user.getId(), skillIds);
            }

            // Create session
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("name", user.getName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setAttribute("profileImage", user.getProfileImage());

            if (user.isFreelancer()) {
                response.sendRedirect(request.getContextPath() + "/freelancer-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/client-dashboard");
            }
        } else {
            request.setAttribute("error", "Failed to create account due to a database error. Please try again.");
            repopulateAttributes(request, name, username, email, role, bio);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void repopulateAttributes(HttpServletRequest request, String name, String username,
                                      String email, String role, String bio) {
        request.setAttribute("name", name);
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("role", role);
        request.setAttribute("bio", bio);
        request.setAttribute("availableSkills", skillDAO.getAllSkills());
    }
}
