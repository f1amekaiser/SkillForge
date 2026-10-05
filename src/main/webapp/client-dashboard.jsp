<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="com.skillforge.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User user = (User) request.getAttribute("user");
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
    Integer wishlistCount = (Integer) request.getAttribute("wishlistCount");
    if (wishlistCount == null) wishlistCount = 0;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Dashboard - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Client Portal</span>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Hello, <%= user != null ? user.getName() : "Client" %>
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">Track your hired student projects and discover new services</p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= ctx %>/services" class="btn btn-primary">+ Hire Talent</a>
                <a href="<%= ctx %>/client-profile" class="btn btn-secondary">Edit Profile</a>
            </div>
        </div>

        <!-- Metric Cards -->
        <div class="grid grid-cols-4" style="margin-bottom: 2.5rem;">
            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Active Projects</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--primary); margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("activeOrders") : 0 %>
                </div>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">In progress or pending</span>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Completed Projects</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--success); margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("completedOrders") : 0 %>
                </div>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">Delivered &amp; approved</span>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Total Invested</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.5rem 0 0.25rem;">
                    ₹<%= stats != null && stats.get("totalSpent") != null ? String.format("%,.0f", ((Number)stats.get("totalSpent")).doubleValue()) : "0" %>
                </div>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">Total student payments</span>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Saved in Wishlist</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #e11d48; margin: 0.5rem 0 0.25rem;">
                    <%= wishlistCount %>
                </div>
                <a href="<%= ctx %>/wishlist" style="font-size: 0.8rem; font-weight: 600;">View wishlist items &rarr;</a>
            </div>
        </div>

        <!-- Recent Orders Table -->
        <div class="card" style="padding: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary);">Recent Orders &amp; Milestones</h2>
                <a href="<%= ctx %>/my-orders" style="font-size: 0.9rem; font-weight: 600;">View All Orders &rarr;</a>
            </div>

            <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Service Title</th>
                                <th>Freelancer</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : recentOrders) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= o.getId() %></td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= o.getServiceTitle() %>
                                        </a>
                                    </td>
                                    <td><%= o.getFreelancerName() %></td>
                                    <td style="font-weight: 700;"><%= o.getFormattedAmount() %></td>
                                    <td>
                                        <span class="badge badge-<%= o.getStatus().toLowerCase() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" class="btn btn-outline btn-sm">
                                            Track Order
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 3rem 1rem;">
                    <div style="width: 48px; height: 48px; background: var(--bg-main); border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center; margin: 0 auto 0.75rem; color: var(--text-muted);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
                    </div>
                    <p style="color: var(--text-muted); margin-bottom: 1rem;">You haven't placed any orders yet.</p>
                    <a href="<%= ctx %>/services" class="btn btn-primary btn-sm">Explore Marketplace</a>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
