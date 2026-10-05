<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Category" %>
<%@ page import="java.util.List" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - SkillForge Admin</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
            <div>
                <a href="<%= ctx %>/admin-dashboard" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Admin Dashboard</a>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Manage Service Categories
                </h1>
                <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                    Configure service taxonomy, domain icons, and catalog descriptions.
                </p>
            </div>
        </div>

        <div class="grid grid-cols-2" style="gap: 2rem; align-items: flex-start;">
            <!-- Left: Add New Category Form -->
            <div class="card" style="padding: 2rem;">
                <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.25rem;">
                    Add New Category
                </h2>

                <form action="<%= ctx %>/admin/categories/action" method="POST">
                    <input type="hidden" name="action" value="create">

                    <div class="form-group">
                        <label class="form-label" for="catName">Category Name *</label>
                        <input type="text" id="catName" name="name" class="form-control" placeholder="e.g. Mobile App Development" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="catIcon">Icon Name / Identifier</label>
                        <input type="text" id="catIcon" name="icon" class="form-control" placeholder="e.g. smartphone or code" value="briefcase">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="catDesc">Description *</label>
                        <textarea id="catDesc" name="description" class="form-control" rows="3" placeholder="Brief summary of services belonging to this category..." required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">Add Category &rarr;</button>
                </form>
            </div>

            <!-- Right: Existing Categories List -->
            <div class="card" style="padding: 2rem;">
                <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.25rem;">
                    Existing Domains (<%= categories != null ? categories.size() : 0 %>)
                </h2>

                <% if (categories != null && !categories.isEmpty()) { %>
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <% for (Category c : categories) { %>
                            <div style="padding: 1rem; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--bg-surface);">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
                                    <div>
                                        <strong style="font-size: 1.05rem;"><%= c.getName() %></strong>
                                        <span class="badge badge-accepted" style="margin-left: 0.5rem;"><%= c.getServiceCount() %> Gigs</span>
                                    </div>
                                    <form action="<%= ctx %>/admin/categories/action" method="POST" onsubmit="return confirm('Delete category? All associated skills will be affected.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= c.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" style="padding: 0.2rem 0.5rem; font-size: 0.75rem;">Delete</button>
                                    </form>
                                </div>
                                <p style="font-size: 0.85rem; color: var(--text-secondary);"><%= c.getDescription() %></p>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
