<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Order> completedOrders = (List<Order>) request.getAttribute("completedOrders");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Earnings - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="margin-bottom: 2rem;">
            <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Finance &amp; Ledger</span>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                Earnings &amp; Payouts
            </h1>
            <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                Track your student freelance revenue, completed milestones, and payout disbursements.
            </p>
        </div>

        <!-- Metrics -->
        <div class="grid grid-cols-3" style="margin-bottom: 2.5rem;">
            <div class="card" style="padding: 2rem; background: linear-gradient(135deg, var(--bg-surface), #f0fdf4); border-color: var(--success);">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Net Student Revenue</div>
                <div style="font-size: 2.5rem; font-weight: 800; color: var(--success); margin: 0.5rem 0 0.25rem;">
                    ₹<%= stats != null && stats.get("totalEarnings") != null ? String.format("%,.0f", ((Number)stats.get("totalEarnings")).doubleValue()) : "0" %>
                </div>
                <span style="font-size: 0.82rem; color: var(--text-secondary);">Directly credited to student account</span>
            </div>

            <div class="card" style="padding: 2rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Completed Deliverables</div>
                <div style="font-size: 2.5rem; font-weight: 800; color: var(--primary); margin: 0.5rem 0 0.25rem;">
                    <%= stats != null ? stats.get("completedOrders") : 0 %>
                </div>
                <span style="font-size: 0.82rem; color: var(--text-secondary);">Orders successfully verified by clients</span>
            </div>

            <div class="card" style="padding: 2rem;">
                <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 700; text-transform: uppercase;">Platform Fee Deducted</div>
                <div style="font-size: 2.5rem; font-weight: 800; color: var(--text-primary); margin: 0.5rem 0 0.25rem;">
                    ₹0.00
                </div>
                <span style="font-size: 0.82rem; color: var(--success); font-weight: 600;">100% Student Retained (0% commission)</span>
            </div>
        </div>

        <!-- Completed Orders Ledger -->
        <div class="card" style="padding: 2rem;">
            <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.5rem;">
                Completed Transactions Ledger
            </h2>

            <% if (completedOrders != null && !completedOrders.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Client Name</th>
                                <th>Service Title</th>
                                <th>Payment Method</th>
                                <th>Completed Date</th>
                                <th>Earned Amount</th>
                                <th>Payout Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : completedOrders) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= o.getId() %></td>
                                    <td><%= o.getClientName() %></td>
                                    <td>
                                        <a href="<%= ctx %>/order-details?id=<%= o.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= o.getServiceTitle() %>
                                        </a>
                                    </td>
                                    <td><%= o.getPaymentMethod() != null ? o.getPaymentMethod() : "UPI" %></td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);"><%= o.getCompletedAt() != null ? o.getCompletedAt() : o.getCreatedAt() %></td>
                                    <td style="font-weight: 800; color: var(--success); font-size: 1.05rem;"><%= o.getFormattedAmount() %></td>
                                    <td>
                                        <span class="badge badge-completed">Disbursed</span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <p style="color: var(--text-muted); text-align: center; padding: 2rem 0;">No completed orders yet. Once a client approves your work, revenue is credited here.</p>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
