<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="com.skillforge.model.Order" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
    List<User> recentUsers = (List<User>) request.getAttribute("recentUsers");
    List<Service> popularServices = (List<Service>) request.getAttribute("popularServices");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Platform Operations</span>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Admin Command Center
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Platform-wide analytics, user moderation, order oversight, and transaction ledgers.
                </p>
            </div>
            <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                <a href="<%= ctx %>/admin/users" class="btn btn-secondary btn-sm">Users</a>
                <a href="<%= ctx %>/admin/services" class="btn btn-secondary btn-sm">Services</a>
                <a href="<%= ctx %>/admin/orders" class="btn btn-secondary btn-sm">Orders</a>
                <a href="<%= ctx %>/admin/categories" class="btn btn-secondary btn-sm">Categories</a>
                <a href="<%= ctx %>/admin/payments" class="btn btn-primary btn-sm">Ledger</a>
            </div>
        </div>

        <!-- 6 Core Platform Metric Cards -->
        <div class="grid grid-cols-3" style="gap: 1.5rem; margin-bottom: 2.5rem;">
            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Total Registered Users</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--primary); margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("totalUsers") : 0 %>
                </div>
                <div style="font-size: 0.8rem; color: var(--text-secondary); display: flex; align-items: center; gap: 0.75rem; margin-top: 0.25rem;">
                    <span style="display: inline-flex; align-items: center; gap: 0.25rem;">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
                        <%= stats != null ? stats.get("totalFreelancers") : 0 %> Freelancers
                    </span>
                    <span>•</span>
                    <span style="display: inline-flex; align-items: center; gap: 0.25rem;">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                        <%= stats != null ? stats.get("totalClients") : 0 %> Clients
                    </span>
                </div>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Active Services</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: var(--accent); margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("totalServices") : 0 %>
                </div>
                <a href="<%= ctx %>/admin/services" style="font-size: 0.8rem; font-weight: 600;">Manage service catalog &rarr;</a>
            </div>

            <div class="card" style="padding: 1.5rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Total Orders Placed</div>
                <div style="font-size: 2.25rem; font-weight: 800; color: #6366f1; margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("totalOrders") : 0 %>
                </div>
                <a href="<%= ctx %>/admin/orders" style="font-size: 0.8rem; font-weight: 600;">Inspect all orders &rarr;</a>
            </div>

            <div class="card" style="padding: 1.5rem; grid-column: span 3; background: linear-gradient(135deg, var(--bg-surface), #eef2ff); border-color: var(--primary);">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Total Platform Mock Revenue</div>
                        <div style="font-size: 2.5rem; font-weight: 800; color: var(--primary); margin: 0.25rem 0;">
                            ₹<%= stats != null && stats.get("totalRevenue") != null ? String.format("%,.2f", ((Number)stats.get("totalRevenue")).doubleValue()) : "0.00" %>
                        </div>
                        <span style="font-size: 0.82rem; color: var(--text-secondary);">Processed across simulated UPI, Card, and Offline payment channels</span>
                    </div>
                    <a href="<%= ctx %>/admin/payments" class="btn btn-primary">View Transaction Ledger &rarr;</a>
                </div>
            </div>
        </div>

        <!-- Tables: Recent Orders & Recent Users -->
        <div class="grid grid-cols-2" style="gap: 2rem; margin-bottom: 2.5rem;">
            <!-- Recent Orders -->
            <div class="card" style="padding: 1.75rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--text-primary);">Recent Orders</h3>
                    <a href="<%= ctx %>/admin/orders" style="font-size: 0.85rem; font-weight: 600;">View All &rarr;</a>
                </div>

                <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table" style="font-size: 0.85rem;">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Service</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Order o : recentOrders) { %>
                                    <tr>
                                        <td style="font-family: var(--font-mono); font-weight: 700;">#<%= o.getId() %></td>
                                        <td><%= o.getServiceTitle() %></td>
                                        <td style="font-weight: 700;"><%= o.getFormattedAmount() %></td>
                                        <td>
                                            <span class="badge badge-<%= o.getStatus().toLowerCase() %>">
                                                <%= o.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>

            <!-- Recent Users -->
            <div class="card" style="padding: 1.75rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--text-primary);">Recent Platform Users</h3>
                    <a href="<%= ctx %>/admin/users" style="font-size: 0.85rem; font-weight: 600;">Manage &rarr;</a>
                </div>

                <% if (recentUsers != null && !recentUsers.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table" style="font-size: 0.85rem;">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User u : recentUsers) { %>
                                    <tr>
                                        <td><strong><%= u.getName() %></strong></td>
                                        <td>@<%= u.getUsername() %></td>
                                        <td><span class="badge badge-accepted"><%= u.getRole() %></span></td>
                                        <td>
                                            <span class="badge badge-<%= "ACTIVE".equalsIgnoreCase(u.getStatus()) ? "completed" : "cancelled" %>">
                                                <%= u.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
