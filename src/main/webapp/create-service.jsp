<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Category" %>
<%@ page import="com.skillforge.dao.CategoryDAO" %>
<%@ page import="java.util.List" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    if (categories == null) {
        CategoryDAO cdao = new CategoryDAO();
        categories = cdao.getAllCategories();
    }
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post a New Service - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem; max-width: 720px;">
        <div class="card" style="padding: 2.5rem;">
            <div style="margin-bottom: 2rem;">
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Gig Creator</span>
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Post a New Student Service
                </h1>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">
                    Offer your skills to campus clubs, researchers, local businesses, and peers.
                </p>
            </div>

            <% if (error != null) { %>
                <div style="background-color: var(--danger-light); color: var(--danger); padding: 0.75rem 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; font-size: 0.88rem; font-weight: 600; border-left: 4px solid var(--danger);">
                    <%= error %>
                </div>
            <% } %>

            <form action="<%= ctx %>/create-service" method="POST" id="serviceForm">
                <div class="form-group">
                    <label class="form-label" for="title">Service Title *</label>
                    <input type="text" id="title" name="title" class="form-control"
                           placeholder="e.g. Build a Modern Full-Stack Website with Java &amp; MySQL" required>
                    <span class="form-hint">Make your title descriptive, action-oriented, and specific.</span>
                </div>

                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="categoryId">Category *</label>
                        <select id="categoryId" name="categoryId" class="form-select" required>
                            <option value="">Select Domain Category</option>
                            <% if (categories != null) { %>
                                <% for (Category c : categories) { %>
                                    <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                <% } %>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="price">Starting Price (₹ INR) *</label>
                        <input type="number" id="price" name="price" class="form-control" placeholder="2500" min="100" step="50" required>
                        <span class="form-hint">Set fair student-friendly pricing in INR.</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="deliveryDays">Expected Delivery Time (Days) *</label>
                    <input type="number" id="deliveryDays" name="deliveryDays" class="form-control" placeholder="3" min="1" max="30" required>
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between;">
                        <label class="form-label" for="description">Comprehensive Service Description *</label>
                        <span id="serviceDescCounter" class="form-hint">0 / 800</span>
                    </div>
                    <textarea id="description" name="description" class="form-control" rows="5" maxlength="800" data-char-counter="serviceDescCounter"
                              placeholder="Detail exactly what deliverables are included, technologies you use, required assets from the buyer, and revision policy..." required></textarea>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary btn-lg" style="flex: 1;">Publish Service &rarr;</button>
                    <a href="<%= ctx %>/my-services" class="btn btn-secondary btn-lg">Cancel</a>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
