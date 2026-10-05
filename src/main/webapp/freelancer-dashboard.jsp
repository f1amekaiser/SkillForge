<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="com.skillforge.model.Order" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User user = (User) request.getAttribute("user");
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
    List<Service> services = (List<Service>) request.getAttribute("services");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Freelancer Dashboard - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Freelancer Studio</span>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Welcome, <%= user != null ? user.getName() : "Freelancer" %>
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Monitor gig performance, incoming milestones, and student earnings
                </p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= ctx %>/create-service" class="btn btn-primary">+ Post New Gig</a>
                <a href="<%= ctx %>/freelancer-profile-edit" class="btn btn-secondary">Edit Skills &amp; Profile</a>
            </div>
        </div>

        <!-- KPI Metrics Grid -->
        <div class="grid grid-cols-4" style="margin-bottom: 2.5rem;">
            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Total Orders</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--primary); margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("totalOrders") : 0 %>
                </div>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">Lifetime student orders</span>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Active Projects</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #6366f1; margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("activeOrders") : 0 %>
                </div>
                <a href="<%= ctx %>/incoming-orders" style="font-size: 0.8rem; font-weight: 600;">Manage incoming work &rarr;</a>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Total Earnings</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--success); margin: 0.5rem 0 0.25rem;">
                    ₹<%= stats != null && stats.get("totalEarnings") != null ? String.format("%,.0f", ((Number)stats.get("totalEarnings")).doubleValue()) : "0" %>
                </div>
                <a href="<%= ctx %>/earnings" style="font-size: 0.8rem; font-weight: 600;">View earnings ledger &rarr;</a>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Client Rating</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #f59e0b; margin: 0.5rem 0 0.25rem; display: flex; align-items: center; gap: 0.35rem;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <%= stats != null ? stats.get("avgRating") : "5.0" %>
                </div>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">Across completed orders</span>
            </div>
        </div>

        <!-- Recent Incoming Orders Table -->
        <div class="card" style="padding: 2rem; margin-bottom: 2.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary);">Incoming &amp; Active Orders</h2>
                <a href="<%= ctx %>/incoming-orders" style="font-size: 0.9rem; font-weight: 600;">View All Orders &rarr;</a>
            </div>

            <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Client Name</th>
                                <th>Service</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : recentOrders) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= o.getId() %></td>
                                    <td><strong><%= o.getClientName() %></strong></td>
                                    <td><%= o.getServiceTitle() %></td>
                                    <td style="font-weight: 700;"><%= o.getFormattedAmount() %></td>
                                    <td>
                                        <span class="badge badge-<%= o.getStatus().toLowerCase() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" class="btn btn-outline btn-sm">
                                            Manage Order
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p style="color: var(--text-muted); text-align: center; padding: 2rem 0;">No incoming orders yet. Share your profile to get clients!</p>
            <% } %>
        </div>

        <!-- My Services Showcase -->
        <div class="card" style="padding: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary);">My Active Gigs</h2>
                <a href="<%= ctx %>/my-services" style="font-size: 0.9rem; font-weight: 600;">Manage All Gigs &rarr;</a>
            </div>

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
                            </div>
                            <div class="service-card-footer">
                                <span class="service-price-val"><%= s.getFormattedPrice() %></span>
                                <a href="<%= ctx %>/edit-service?id=<%= s.getId() %>" class="btn btn-secondary btn-sm">Edit Gig</a>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <p style="grid-column: 1 / -1; color: var(--text-muted);">You haven't posted any gigs yet. Click "Post New Gig" above to start freelancing!</p>
                <% } %>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
