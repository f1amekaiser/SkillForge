package com.skillforge.controller;

import com.skillforge.dao.UserDAO;
import com.skillforge.model.User;
import com.skillforge.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("role");
            redirectBasedOnRole(response, request.getContextPath(), role);
            return;
        }

        // Check for "rememberUser" cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberUser".equals(cookie.getName())) {
                    request.setAttribute("rememberedUsername", cookie.getValue());
                    break;
                }
            }
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        String redirect = request.getParameter("redirect");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username/email and password are required.");
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String passwordHash = PasswordUtil.hashPassword(password);
        User user = userDAO.authenticate(usernameOrEmail.trim(), passwordHash);

        if (user == null) {
            request.setAttribute("error", "Invalid username or password.");
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (user.isBlocked()) {
            request.setAttribute("error", "Your account has been deactivated. Please contact support.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create Session
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("name", user.getName());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("role", user.getRole());
        session.setAttribute("profileImage", user.getProfileImage());

        // Handle "Remember Me" Cookie
        if ("true".equalsIgnoreCase(rememberMe) || "on".equalsIgnoreCase(rememberMe)) {
            Cookie rememberCookie = new Cookie("rememberUser", user.getUsername());
            rememberCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            rememberCookie.setPath(request.getContextPath() + "/");
            rememberCookie.setHttpOnly(true);
            response.addCookie(rememberCookie);
        } else {
            // Delete cookie if unchecked
            Cookie rememberCookie = new Cookie("rememberUser", "");
            rememberCookie.setMaxAge(0);
            rememberCookie.setPath(request.getContextPath() + "/");
            response.addCookie(rememberCookie);
        }

        if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login")) {
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            redirectBasedOnRole(response, request.getContextPath(), user.getRole());
        }
    }

    private void redirectBasedOnRole(HttpServletResponse response, String contextPath, String role)
            throws IOException {
        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/admin-dashboard");
        } else if ("FREELANCER".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/freelancer-dashboard");
        } else {
            response.sendRedirect(contextPath + "/client-dashboard");
        }
    }
}
