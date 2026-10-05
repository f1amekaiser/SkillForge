<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="com.skillforge.model.Category" %>
<%@ page import="com.skillforge.dao.ServiceDAO" %>
<%@ page import="com.skillforge.dao.CategoryDAO" %>
<%@ page import="java.util.List" %>
<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    if (services == null) {
        ServiceDAO sdao = new ServiceDAO();
        services = sdao.searchAndFilterServices(null, null, null, null, null, null, null);
    }
    if (categories == null) {
        CategoryDAO cdao = new CategoryDAO();
        categories = cdao.getAllCategories();
    }
    Integer selectedCategory = (Integer) request.getAttribute("selectedCategory");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services Marketplace - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 2.5rem 1.5rem;">
        <!-- Header & Live Search Bar -->
        <div style="margin-bottom: 2rem;">
            <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">Student Marketplace</span>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 1rem;">Explore Student Services</h1>

            <!-- Live AJAX Search Input -->
            <div style="position: relative; max-width: 800px;">
                <input type="text" id="marketplaceSearchInput" class="form-control"
                       style="padding: 1rem 1.25rem; font-size: 1.05rem; border-radius: var(--radius-lg); box-shadow: var(--shadow-sm);"
                       placeholder="Search for services, skills or freelancers (e.g. Java, Python, Figma, React)...">
                <span id="searchStatus" style="display: none; position: absolute; right: 1.25rem; top: 1.1rem; font-size: 0.85rem; color: var(--primary);">
                    Searching...
                </span>
            </div>
        </div>

        <!-- Filter Controls -->
        <div class="card" style="padding: 1.25rem; margin-bottom: 2rem;">
            <div style="display: flex; flex-wrap: wrap; gap: 1rem; align-items: center; justify-content: space-between;">
                <div style="display: flex; flex-wrap: wrap; gap: 1rem; align-items: center; flex: 1;">
                    <!-- Category Filter -->
                    <div style="min-width: 180px;">
                        <label class="form-label" style="font-size: 0.8rem; margin-bottom: 0.2rem;">Category</label>
                        <select id="categoryFilter" class="form-select" style="padding: 0.5rem 0.75rem; font-size: 0.88rem;">
                            <option value="">All Categories</option>
                            <% for (Category c : categories) { %>
                                <option value="<%= c.getId() %>" <%= selectedCategory != null && selectedCategory == c.getId() ? "selected" : "" %>>
                                    <%= c.getName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Price Min/Max -->
                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                        <div>
                            <label class="form-label" style="font-size: 0.8rem; margin-bottom: 0.2rem;">Min ₹</label>
                            <input type="number" id="minPriceInput" class="form-control" placeholder="500" style="width: 90px; padding: 0.5rem 0.65rem; font-size: 0.88rem;">
                        </div>
                        <div>
                            <label class="form-label" style="font-size: 0.8rem; margin-bottom: 0.2rem;">Max ₹</label>
                            <input type="number" id="maxPriceInput" class="form-control" placeholder="5000" style="width: 90px; padding: 0.5rem 0.65rem; font-size: 0.88rem;">
                        </div>
                    </div>

                    <!-- Rating Filter -->
                    <div style="min-width: 130px;">
                        <label class="form-label" style="font-size: 0.8rem; margin-bottom: 0.2rem;">Rating</label>
                        <select id="ratingFilter" class="form-select" style="padding: 0.5rem 0.75rem; font-size: 0.88rem;">
                            <option value="">Any Rating</option>
                            <option value="4.5">4.5+ Stars</option>
                            <option value="4.0">4.0+ Stars</option>
                            <option value="3.0">3.0+ Stars</option>
                        </select>
                    </div>

                    <!-- Delivery Filter -->
                    <div style="min-width: 140px;">
                        <label class="form-label" style="font-size: 0.8rem; margin-bottom: 0.2rem;">Delivery Time</label>
                        <select id="deliveryFilter" class="form-select" style="padding: 0.5rem 0.75rem; font-size: 0.88rem;">
                            <option value="">Any Time</option>
                            <option value="1">Up to 24 Hours</option>
                            <option value="3">Up to 3 Days</option>
                            <option value="7">Up to 7 Days</option>
                        </select>
                    </div>
                </div>

                <!-- Sorting -->
                <div style="min-width: 170px;">
                    <label class="form-label" style="font-size: 0.8rem; margin-bottom: 0.2rem;">Sort By</label>
                    <select id="sortSelect" class="form-select" style="padding: 0.5rem 0.75rem; font-size: 0.88rem;">
                        <option value="relevance">Popular / Relevant</option>
                        <option value="price_asc">Price: Low to High</option>
                        <option value="price_desc">Price: High to Low</option>
                        <option value="rating">Highest Rated</option>
                        <option value="newest">Newest First</option>
                    </select>
                </div>
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1rem; padding-top: 0.75rem; border-top: 1px solid var(--border); font-size: 0.85rem; color: var(--text-secondary);">
                <span id="resultCount"><%= services.size() %> services available</span>
                <span style="color: var(--primary); font-weight: 600; display: inline-flex; align-items: center; gap: 0.35rem;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                    Powered by AJAX Live Filtering
                </span>
            </div>
        </div>

        <!-- Services Grid -->
        <div id="servicesGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem;">
            <% if (services == null || services.isEmpty()) { %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem; background: var(--bg-surface); border-radius: var(--radius-lg); border: 1px dashed var(--border);">
                    <div style="width: 56px; height: 56px; background: var(--bg-main); border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem; color: var(--text-muted);">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem; color: var(--text-primary);">No services listed in this category yet</h3>
                    <p style="color: var(--text-secondary); max-width: 420px; margin: 0 auto 1.5rem; font-size: 0.9rem;">
                        As more student freelancers register and publish their gigs, their listings will dynamically appear here.
                    </p>
                    <a href="<%= ctx %>/services" class="btn btn-secondary btn-sm">View All Services</a>
                </div>
            <% } else { %>
                <% for (Service s : services) { %>
                    <div class="service-card">
                        <div class="service-card-body">
                            <div class="service-freelancer">
                                <div class="user-avatar" style="width: 36px; height: 36px;">
                                    <%= s.getFreelancerName().substring(0, 1) %>
                                </div>
                                <div class="service-freelancer-info">
                                    <h4><a href="<%= ctx %>/freelancer-profile?id=<%= s.getFreelancerId() %>"><%= s.getFreelancerName() %></a></h4>
                                    <span>@<%= s.getFreelancerUsername() %></span>
                                </div>
                            </div>

                            <span class="service-category-badge"><%= s.getCategoryName() %></span>
                            <h3 class="service-card-title">
                                <a href="<%= ctx %>/service-details?id=<%= s.getId() %>"><%= s.getTitle() %></a>
                            </h3>
                            <p class="service-card-desc"><%= s.getDescription() %></p>

                            <div class="service-rating" style="display: flex; align-items: center; gap: 0.35rem;">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                <span style="font-weight: 700; color: var(--text-primary);"><%= String.format("%.1f", s.getRating()) %></span>
                                <span class="count">(<%= s.getReviewCount() %> reviews)</span>
                            </div>

                            <div style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.35rem;">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                Delivery: <strong><%= s.getDeliveryDays() %> <%= s.getDeliveryDays() == 1 ? "day" : "days" %></strong>
                            </div>
                        </div>

                        <div class="service-card-footer">
                            <div class="service-price-block">
                                <span class="service-price-label">Starting at</span>
                                <span class="service-price-val"><%= s.getFormattedPrice() %></span>
                            </div>
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <button class="wishlist-btn-heart" onclick="toggleWishlist(<%= s.getId() %>, this)" title="Add to Wishlist" style="display: flex; align-items: center; justify-content: center;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                </button>
                                <a href="<%= ctx %>/service-details?id=<%= s.getId() %>" class="btn btn-primary btn-sm">View Service</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
