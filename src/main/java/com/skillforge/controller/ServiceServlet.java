package com.skillforge.controller;

import com.skillforge.dao.*;
import com.skillforge.model.Category;
import com.skillforge.model.Review;
import com.skillforge.model.Service;
import com.skillforge.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/services", "/service-details", "/freelancer-profile", "/categories"})
public class ServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/service-details".equals(path)) {
            handleServiceDetails(request, response);
        } else if ("/freelancer-profile".equals(path)) {
            handleFreelancerProfile(request, response);
        } else if ("/categories".equals(path)) {
            handleCategoriesPage(request, response);
        } else {
            handleServicesCatalog(request, response);
        }
    }

    private void handleServicesCatalog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        String categoryIdStr = request.getParameter("category");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String minRatingStr = request.getParameter("rating");
        String deliveryDaysStr = request.getParameter("delivery");
        String sortBy = request.getParameter("sortBy");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
                // Save preferred category cookie
                Cookie prefCookie = new Cookie("preferredCategory", categoryId.toString());
                prefCookie.setMaxAge(7 * 24 * 60 * 60);
                prefCookie.setPath(request.getContextPath() + "/");
                response.addCookie(prefCookie);
            } catch (NumberFormatException ignored) {}
        } else {
            // Check cookie if no category parameter specified
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("preferredCategory".equals(c.getName())) {
                        try {
                            request.setAttribute("preferredCategoryFromCookie", Integer.parseInt(c.getValue()));
                        } catch (NumberFormatException ignored) {}
                        break;
                    }
                }
            }
        }

        Double minPrice = null;
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try { minPrice = Double.parseDouble(minPriceStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Double maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try { maxPrice = Double.parseDouble(maxPriceStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Double minRating = null;
        if (minRatingStr != null && !minRatingStr.trim().isEmpty()) {
            try { minRating = Double.parseDouble(minRatingStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Integer deliveryDays = null;
        if (deliveryDaysStr != null && !deliveryDaysStr.trim().isEmpty()) {
            try { deliveryDays = Integer.parseInt(deliveryDaysStr.trim()); } catch (NumberFormatException ignored) {}
        }

        List<Service> services = serviceDAO.searchAndFilterServices(
                query, categoryId, minPrice, maxPrice, minRating, deliveryDays, sortBy
        );

        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        request.setAttribute("query", query);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("/services.jsp").forward(request, response);
    }

    private void handleServiceDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(idStr.trim());
            Service service = serviceDAO.getById(serviceId);

            if (service == null) {
                request.setAttribute("errorMessage", "Service not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            User freelancer = userDAO.findById(service.getFreelancerId());
            List<Review> reviews = reviewDAO.getReviewsByServiceId(serviceId);

            // Check if service is wishlisted by current user
            HttpSession session = request.getSession(false);
            boolean inWishlist = false;
            if (session != null && session.getAttribute("userId") != null) {
                int currentUserId = (Integer) session.getAttribute("userId");
                inWishlist = wishlistDAO.isInWishlist(currentUserId, serviceId);
            }

            request.setAttribute("service", service);
            request.setAttribute("freelancer", freelancer);
            request.setAttribute("reviews", reviews);
            request.setAttribute("inWishlist", inWishlist);

            request.getRequestDispatcher("/service-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }

    private void handleFreelancerProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String username = request.getParameter("username");

        User freelancer = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                freelancer = userDAO.findById(Integer.parseInt(idStr.trim()));
            } catch (NumberFormatException ignored) {}
        } else if (username != null && !username.trim().isEmpty()) {
            freelancer = userDAO.findByUsername(username.trim());
        }

        if (freelancer == null || !freelancer.isFreelancer()) {
            request.setAttribute("errorMessage", "Freelancer profile not found.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        List<Service> services = serviceDAO.getByFreelancerId(freelancer.getId());
        List<Review> reviews = reviewDAO.getReviewsByFreelancerId(freelancer.getId());

        OrderDAO orderDAO = new OrderDAO();
        request.setAttribute("freelancer", freelancer);
        request.setAttribute("services", services);
        request.setAttribute("reviews", reviews);
        request.setAttribute("stats", orderDAO.getFreelancerStats(freelancer.getId()));

        request.getRequestDispatcher("/freelancer-profile.jsp").forward(request, response);
    }

    private void handleCategoriesPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/categories.jsp").forward(request, response);
    }
}
