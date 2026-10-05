<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="com.skillforge.model.Review" %>
<%@ page import="com.skillforge.model.Skill" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User freelancer = (User) request.getAttribute("freelancer");
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= freelancer != null ? freelancer.getName() : "Freelancer Profile" %> - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <% if (freelancer != null) { %>
            <!-- Profile Header Card -->
            <div class="card" style="padding: 2.5rem; margin-bottom: 2.5rem;">
                <div style="display: flex; flex-wrap: wrap; gap: 2rem; align-items: center;">
                    <div class="user-avatar" style="width: 100px; height: 100px; font-size: 2.5rem; border: 4px solid var(--primary-light);">
                        <%= freelancer.getName().substring(0, 1) %>
                    </div>
                    <div style="flex: 1; min-width: 250px;">
                        <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.25rem;">
                            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary);"><%= freelancer.getName() %></h1>
                            <span class="badge badge-accepted">Student Freelancer</span>
                        </div>
                        <div style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 0.75rem;">
                            @<%= freelancer.getUsername() %> • Member since 2026
                        </div>
                        <p style="color: var(--text-secondary); font-size: 0.95rem; max-width: 700px; line-height: 1.5; margin-bottom: 1rem;">
                            <%= freelancer.getBio() %>
                        </p>

                        <% if (freelancer.getSkills() != null && !freelancer.getSkills().isEmpty()) { %>
                            <div class="service-tags">
                                <% for (Skill sk : freelancer.getSkills()) { %>
                                    <span class="service-tag"><%= sk.getName() %></span>
                                <% } %>
                            </div>
                        <% } %>
                    </div>

                    <!-- Profile KPI Stats -->
                    <% if (stats != null) { %>
                        <div style="display: flex; gap: 1.5rem; background: var(--bg-subtle); padding: 1.25rem 1.5rem; border-radius: var(--radius-md); text-align: center;">
                            <div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--primary);"><%= stats.get("completedOrders") %></div>
                                <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700;">Completed</div>
                            </div>
                            <div style="width: 1px; background: var(--border);"></div>
                            <div>
                                <div style="font-size: 1.5rem; font-weight: 800; color: #f59e0b; display: flex; align-items: center; justify-content: center; gap: 0.35rem;">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <%= stats.get("avgRating") %>
                                </div>
                                <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700;">Rating</div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Freelancer Services Section -->
            <div style="margin-bottom: 3rem;">
                <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.5rem;">
                    Services Offered by <%= freelancer.getName().split(" ")[0] %> (<%= services != null ? services.size() : 0 %>)
                </h2>

                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem;">
                    <% if (services != null && !services.isEmpty()) { %>
                        <% for (Service s : services) { %>
                            <div class="service-card">
                                <div class="service-card-body">
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
                                    <a href="<%= ctx %>/service-details?id=<%= s.getId() %>" class="btn btn-primary btn-sm">Hire Now</a>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p style="grid-column: 1 / -1; color: var(--text-muted);">This freelancer currently has no active public services.</p>
                    <% } %>
                </div>
            </div>

            <!-- Client Reviews Section -->
            <div class="card" style="padding: 2rem;">
                <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.5rem;">
                    Client Feedback &amp; Testimonials
                </h2>

                <% if (reviews != null && !reviews.isEmpty()) { %>
                    <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                        <% for (Review r : reviews) { %>
                            <div style="padding-bottom: 1.25rem; border-bottom: 1px solid var(--border);">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.4rem;">
                                    <div style="font-weight: 700; font-size: 0.95rem;"><%= r.getClientName() %></div>
                                    <div style="display: flex; align-items: center; gap: 0.25rem;">
                                        <%= r.getStarsSvg() %>
                                        <span style="color: var(--text-primary); font-size: 0.85rem; font-weight: 700; margin-left: 0.25rem;">(<%= r.getRating() %>/5)</span>
                                    </div>
                                </div>
                                <div style="font-size: 0.82rem; color: var(--primary); margin-bottom: 0.4rem; font-weight: 600;">
                                    Project: <%= r.getServiceTitle() %>
                                </div>
                                <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.5;">
                                    <%= r.getComment() %>
                                </p>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p style="color: var(--text-muted);">No reviews posted yet.</p>
                <% } %>
            </div>
        <% } %>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
