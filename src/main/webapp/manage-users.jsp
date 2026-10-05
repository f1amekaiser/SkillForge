<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="java.util.List" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    String selectedRole = (String) request.getAttribute("selectedRole");
    if (selectedRole == null) selectedRole = "ALL";
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - SkillForge Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <a href="<%= ctx %>/admin-dashboard" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Admin Dashboard</a>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    User Management
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Oversee student freelancers and clients. Block or unblock accounts as needed.
                </p>
            </div>

            <!-- Role Filter -->
            <div style="display: flex; gap: 0.5rem;">
                <a href="<%= ctx %>/admin/users?role=ALL" class="btn <%= "ALL".equalsIgnoreCase(selectedRole) ? "btn-primary" : "btn-secondary" %> btn-sm">All</a>
                <a href="<%= ctx %>/admin/users?role=FREELANCER" class="btn <%= "FREELANCER".equalsIgnoreCase(selectedRole) ? "btn-primary" : "btn-secondary" %> btn-sm">Freelancers</a>
                <a href="<%= ctx %>/admin/users?role=CLIENT" class="btn <%= "CLIENT".equalsIgnoreCase(selectedRole) ? "btn-primary" : "btn-secondary" %> btn-sm">Clients</a>
            </div>
        </div>

        <div class="card" style="padding: 2rem;">
            <% if (users != null && !users.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : users) { %>
                                <tr>
                                    <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">#<%= u.getId() %></td>
                                    <td><strong><%= u.getName() %></strong></td>
                                    <td>@<%= u.getUsername() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><span class="badge badge-accepted"><%= u.getRole() %></span></td>
                                    <td>
                                        <span class="badge badge-<%= "ACTIVE".equalsIgnoreCase(u.getStatus()) ? "completed" : "cancelled" %>">
                                            <%= u.getStatus() %>
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);"><%= u.getCreatedAt() %></td>
                                    <td>
                                        <% if (!u.isAdmin()) { %>
                                            <form action="<%= ctx %>/admin/users/action" method="POST" style="display:inline;">
                                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                                <% if ("ACTIVE".equalsIgnoreCase(u.getStatus())) { %>
                                                    <input type="hidden" name="action" value="block">
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Block this user?');">Block</button>
                                                <% } else { %>
                                                    <input type="hidden" name="action" value="unblock">
                                                    <button type="submit" class="btn btn-success btn-sm">Unblock</button>
                                                <% } %>
                                            </form>
                                        <% } else { %>
                                            <span style="font-size: 0.8rem; color: var(--text-muted);">Admin</span>
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
