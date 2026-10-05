<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem; max-width: 600px;">
        <div class="card" style="padding: 2.5rem;">
            <div style="margin-bottom: 2rem;">
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.25rem;">
                    Manage Client Profile
                </h1>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">
                    Update your account details and contact identity.
                </p>
            </div>

            <% if (user != null) { %>
                <form action="<%= ctx %>/client-profile" method="POST">
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" value="<%= user.getUsername() %>" disabled style="background-color: var(--bg-subtle);">
                        <span class="form-hint">Username cannot be changed.</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" class="form-control" value="<%= user.getEmail() %>" disabled style="background-color: var(--bg-subtle);">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="name">Display Name *</label>
                        <input type="text" id="name" name="name" class="form-control" value="<%= user.getName() %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="bio">Organization / Bio</label>
                        <textarea id="bio" name="bio" class="form-control" rows="3" placeholder="Tell student freelancers about yourself or your organization..."><%= user.getBio() != null ? user.getBio() : "" %></textarea>
                    </div>

                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                        <a href="<%= ctx %>/client-dashboard" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
