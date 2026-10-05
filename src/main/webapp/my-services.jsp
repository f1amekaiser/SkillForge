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
    <title>My Services - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Freelancer Inventory</span>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    My Service Gigs
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Manage your service listings, adjust prices, and toggle gig visibility.
                </p>
            </div>
            <a href="<%= ctx %>/create-service" class="btn btn-primary">+ Post New Gig</a>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (services != null && !services.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Gig Title</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Delivery</th>
                                <th>Rating</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Service s : services) { %>
                                <tr>
                                    <td>
                                        <a href="<%= ctx %>/service-details?id=<%= s.getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                            <%= s.getTitle() %>
                                        </a>
                                    </td>
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
                                        <span class="badge badge-<%= s.getStatus().toLowerCase() %>">
                                            <%= s.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="<%= ctx %>/edit-service?id=<%= s.getId() %>" class="btn btn-secondary btn-sm">Edit</a>
                                            <form action="<%= ctx %>/delete-service" method="POST" onsubmit="return confirm('Are you sure you want to remove this service?');">
                                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                            </form>
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
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">No services listed yet</h3>
                    <p style="color: var(--text-secondary); max-width: 420px; margin: 0 auto 1.5rem;">
                        Start by creating your first service listing with title, description, and starting rate.
                    </p>
                    <a href="<%= ctx %>/create-service" class="btn btn-primary">Create First Service</a>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
