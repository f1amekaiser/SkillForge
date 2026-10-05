<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="java.util.List" %>
<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Services - SkillForge Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="margin-bottom: 2rem;">
            <a href="<%= ctx %>/admin-dashboard" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Admin Dashboard</a>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                Platform Services Moderation
            </h1>
            <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                Review all active student listings and take down inappropriate or flagged services.
            </p>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (services != null && !services.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Freelancer</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Rating</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Service s : services) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= s.getId() %></td>
                                    <td>
                                        <a href="<%= ctx %>/service-details?id=<%= s.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= s.getTitle() %>
                                        </a>
                                    </td>
                                    <td><%= s.getFreelancerName() %></td>
                                    <td><span class="service-category-badge" style="margin-bottom:0;"><%= s.getCategoryName() %></span></td>
                                    <td style="font-weight: 700;"><%= s.getFormattedPrice() %></td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 0.3rem;">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                            <span><%= String.format("%.1f", s.getRating()) %></span>
                                            <span style="color: var(--text-muted); font-size: 0.8rem;">(<%= s.getReviewCount() %>)</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-<%= "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "completed" : "cancelled" %>">
                                            <%= s.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (!"REMOVED".equalsIgnoreCase(s.getStatus())) { %>
                                            <form action="<%= ctx %>/admin/services/action" method="POST" onsubmit="return confirm('Remove this service from platform?');">
                                                <input type="hidden" name="serviceId" value="<%= s.getId() %>">
                                                <input type="hidden" name="action" value="remove">
                                                <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                            </form>
                                        <% } else { %>
                                            <span style="font-size: 0.8rem; color: var(--text-muted);">Removed</span>
                                        <% } %>
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
