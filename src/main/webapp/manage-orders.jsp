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
    <title>Manage Orders - SkillForge Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="margin-bottom: 2rem;">
            <a href="<%= ctx %>/admin-dashboard" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Admin Dashboard</a>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                All Platform Orders
            </h1>
            <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                Track lifecycle milestones, payments, and intervene in disputed deliveries.
            </p>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (orders != null && !orders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order</th>
                                <th>Service Title</th>
                                <th>Client</th>
                                <th>Freelancer</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Override Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>">#<%= o.getId() %></a>
                                    </td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= o.getServiceTitle() %>
                                        </a>
                                    </td>
                                    <td><%= o.getClientName() %></td>
                                    <td><%= o.getFreelancerName() %></td>
                                    <td style="font-weight: 700;"><%= o.getFormattedAmount() %></td>
                                    <td>
                                        <span class="badge badge-<%= o.getStatus().toLowerCase() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="<%= ctx %>/admin/orders/action" method="POST" style="display:flex; gap:0.4rem;">
                                            <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                            <select name="status" class="form-select" style="padding: 0.3rem 0.5rem; font-size: 0.8rem; width: auto;">
                                                <option value="PENDING" <%= "PENDING".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>PENDING</option>
                                                <option value="ACCEPTED" <%= "ACCEPTED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>ACCEPTED</option>
                                                <option value="IN_PROGRESS" <%= "IN_PROGRESS".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
                                                <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>DELIVERED</option>
                                                <option value="COMPLETED" <%= "COMPLETED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>COMPLETED</option>
                                                <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(o.getStatus()) ? "selected" : "" %>>CANCELLED</option>
                                            </select>
                                            <button type="submit" class="btn btn-secondary btn-sm">Update</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
