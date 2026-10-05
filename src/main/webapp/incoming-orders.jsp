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
    <title>Incoming Orders - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="margin-bottom: 2rem;">
            <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Order Management</span>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                Incoming Client Orders
            </h1>
            <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                Accept client requests, commence development, and submit finished project deliverables.
            </p>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (orders != null && !orders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Client</th>
                                <th>Service Title</th>
                                <th>Amount</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action / Next Step</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= o.getId() %></td>
                                    <td>
                                        <strong><%= o.getClientName() %></strong><br>
                                        <span style="font-size: 0.78rem; color: var(--text-muted);"><%= o.getClientEmail() %></span>
                                    </td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= o.getServiceTitle() %>
                                        </a>
                                    </td>
                                    <td style="font-weight: 700; color: var(--success);"><%= o.getFormattedAmount() %></td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);"><%= o.getCreatedAt() %></td>
                                    <td>
                                        <span class="badge badge-<%= o.getStatus().toLowerCase() %>">
                                            <%= o.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.4rem; align-items: center;">
                                            <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" class="btn btn-primary btn-sm">
                                                Manage &rarr;
                                            </a>
                                            <% if ("PENDING".equalsIgnoreCase(o.getStatus())) { %>
                                                <form action="<%= ctx %>/order/action" method="POST" style="display:inline;">
                                                    <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                                    <input type="hidden" name="action" value="accept">
                                                    <button type="submit" class="btn btn-success btn-sm">Accept</button>
                                                </form>
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
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">No incoming orders</h3>
                    <p style="color: var(--text-secondary); max-width: 420px; margin: 0 auto;">
                        When clients hire your services, their project requirements and orders will appear here.
                    </p>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
