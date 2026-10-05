<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Order" %>
<%@ page import="java.util.List" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Client Dashboard</span>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    My Orders &amp; Project Trackers
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Manage deliverables, approve project milestones, and review completed work.
                </p>
            </div>
            <a href="<%= ctx %>/services" class="btn btn-primary">+ Place New Order</a>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (orders != null && !orders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Service Title</th>
                                <th>Freelancer</th>
                                <th>Amount</th>
                                <th>Date Placed</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= o.getId() %></td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= o.getServiceTitle() %>
                                        </a>
                                    </td>
                                    <td><%= o.getFreelancerName() %></td>
                                    <td style="font-weight: 700;"><%= o.getFormattedAmount() %></td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);"><%= o.getCreatedAt() %></td>
                                    <td>
                                        <span class="badge badge-<%= o.getStatus().toLowerCase() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem; align-items: center;">
                                            <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" class="btn btn-outline btn-sm">
                                                Track
                                            </a>
                                            <% if ("COMPLETED".equalsIgnoreCase(o.getStatus())) { %>
                                                <% if (!o.isReviewed()) { %>
                                                    <a href="<%= ctx %>/review?orderId=<%= o.getId() %>" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 0.3rem;">
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                                        Review
                                                    </a>
                                                <% } else { %>
                                                    <span style="font-size: 0.8rem; color: var(--success); font-weight: 700; display: inline-flex; align-items: center; gap: 0.25rem;">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                        Reviewed
                                                    </span>
                                                <% } %>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 4rem 1.5rem;">
                    <div style="width: 56px; height: 56px; background: var(--bg-main); border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem; color: var(--text-muted);">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">No orders placed yet</h3>
                    <p style="color: var(--text-secondary); max-width: 420px; margin: 0 auto 1.5rem;">
                        Explore our student marketplace to hire developers, designers, and content creators.
                    </p>
                    <a href="<%= ctx %>/services" class="btn btn-primary">Discover Services Now</a>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
