<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Ledger - SkillForge Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <a href="<%= ctx %>/admin-dashboard" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Admin Dashboard</a>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Financial Transactions &amp; Mock Ledger
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Auditable log of all simulated mock payments across UPI, Card, and Offline channels.
                </p>
            </div>

            <!-- Total Revenue Badge -->
            <div class="card" style="padding: 1rem 1.75rem; background: var(--bg-surface); text-align: right; border-color: var(--primary);">
                <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700;">Total Processed</div>
                <div style="font-size: 1.75rem; font-weight: 800; color: var(--primary);">
                    ₹<%= String.format("%,.2f", totalRevenue.doubleValue()) %>
                </div>
            </div>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (payments != null && !payments.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Transaction ID</th>
                                <th>Order Ref</th>
                                <th>Client Name</th>
                                <th>Service Title</th>
                                <th>Method</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Date &amp; Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Payment p : payments) { %>
                                <tr>
                                    <td>
                                        <code style="font-family: var(--font-mono); font-size: 0.85rem; font-weight: 700; color: var(--primary);">
                                            <%= p.getTransactionId() %>
                                        </code>
                                    </td>
                                    <td style="font-family: var(--font-mono);">
                                        <a href="<%= ctx %>/order-details?id=<%= p.getOrderId() %>">#<%= p.getOrderId() %></a>
                                    </td>
                                    <td><strong><%= p.getClientName() %></strong></td>
                                    <td><%= p.getServiceTitle() %></td>
                                    <td>
                                        <span class="badge badge-accepted"><%= p.getPaymentMethod() %></span>
                                    </td>
                                    <td style="font-weight: 800; color: var(--success);"><%= p.getFormattedAmount() %></td>
                                    <td>
                                        <span class="badge badge-completed"><%= p.getStatus() %></span>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);"><%= p.getPaymentDate() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p style="text-align: center; color: var(--text-muted); padding: 3rem 0;">No transactions recorded in ledger.</p>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
