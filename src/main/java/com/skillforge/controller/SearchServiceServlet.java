package com.skillforge.controller;

import com.google.gson.Gson;
import com.skillforge.dao.ServiceDAO;
import com.skillforge.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/search-services")
public class SearchServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        String categoryIdStr = request.getParameter("categoryId");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String minRatingStr = request.getParameter("minRating");
        String deliveryDaysStr = request.getParameter("deliveryDays");
        String sortBy = request.getParameter("sortBy");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        Double minPrice = null;
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        Double maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        Double minRating = null;
        if (minRatingStr != null && !minRatingStr.trim().isEmpty()) {
            try {
                minRating = Double.parseDouble(minRatingStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        Integer deliveryDays = null;
        if (deliveryDaysStr != null && !deliveryDaysStr.trim().isEmpty()) {
            try {
                deliveryDays = Integer.parseInt(deliveryDaysStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Service> services = serviceDAO.searchAndFilterServices(
                query, categoryId, minPrice, maxPrice, minRating, deliveryDays, sortBy
        );

        response.getWriter().write(gson.toJson(services));
    }
}
