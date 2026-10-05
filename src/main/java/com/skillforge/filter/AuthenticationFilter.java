package com.skillforge.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    private static final List<String> CLIENT_PATHS = Arrays.asList(
            "/client-dashboard", "/client-dashboard.jsp",
            "/wishlist", "/wishlist.jsp",
            "/checkout", "/checkout.jsp",
            "/payment", "/payment.jsp",
            "/my-orders", "/my-orders.jsp",
            "/review", "/review.jsp",
            "/client-profile", "/client-profile.jsp"
    );

    private static final List<String> FREELANCER_PATHS = Arrays.asList(
            "/freelancer-dashboard", "/freelancer-dashboard.jsp",
            "/freelancer-profile-edit", "/freelancer-profile-edit.jsp",
            "/create-service", "/create-service.jsp",
            "/edit-service", "/edit-service.jsp",
            "/my-services", "/my-services.jsp",
            "/incoming-orders", "/incoming-orders.jsp",
            "/earnings", "/earnings.jsp"
    );

    private static final List<String> ADMIN_PATHS = Arrays.asList(
            "/admin-dashboard", "/admin-dashboard.jsp",
            "/admin/users", "/manage-users.jsp",
            "/admin/services", "/manage-services.jsp",
            "/admin/orders", "/manage-orders.jsp",
            "/admin/categories", "/manage-categories.jsp",
            "/admin/payments", "/manage-payments.jsp"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI().substring(contextPath.length());

        // Skip static assets
        if (uri.startsWith("/css/") || uri.startsWith("/js/") || uri.startsWith("/images/") ||
            uri.startsWith("/xml/") || uri.equals("/favicon.ico")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        // Check Admin Paths
        if (matchesPath(uri, ADMIN_PATHS)) {
            if (userId == null) {
                res.sendRedirect(contextPath + "/login.jsp?redirect=" + req.getServletPath());
                return;
            }
            if (!"ADMIN".equalsIgnoreCase(role)) {
                res.sendRedirect(contextPath + "/access-denied.jsp");
                return;
            }
        }

        // Check Freelancer Paths
        if (matchesPath(uri, FREELANCER_PATHS)) {
            if (userId == null) {
                res.sendRedirect(contextPath + "/login.jsp?redirect=" + req.getServletPath());
                return;
            }
            if (!"FREELANCER".equalsIgnoreCase(role)) {
                res.sendRedirect(contextPath + "/access-denied.jsp");
                return;
            }
        }

        // Check Client Paths
        if (matchesPath(uri, CLIENT_PATHS)) {
            if (userId == null) {
                res.sendRedirect(contextPath + "/login.jsp?redirect=" + req.getServletPath());
                return;
            }
            if (!"CLIENT".equalsIgnoreCase(role)) {
                res.sendRedirect(contextPath + "/access-denied.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean matchesPath(String uri, List<String> paths) {
        for (String path : paths) {
            if (uri.equalsIgnoreCase(path) || uri.startsWith(path + "/")) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {}
}
