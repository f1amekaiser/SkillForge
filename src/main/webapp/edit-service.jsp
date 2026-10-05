<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="com.skillforge.model.Category" %>
<%@ page import="java.util.List" %>
<%
    Service service = (Service) request.getAttribute("service");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Service - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem; max-width: 720px;">
        <% if (service != null) { %>
            <div class="card" style="padding: 2.5rem;">
                <div style="margin-bottom: 2rem;">
                    <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Gig Editor</span>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                        Edit Service Details
                    </h1>
                </div>

                <% if (error != null) { %>
                    <div style="background-color: var(--danger-light); color: var(--danger); padding: 0.75rem 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; font-size: 0.88rem; font-weight: 600; border-left: 4px solid var(--danger);">
                        <%= error %>
                    </div>
                <% } %>

                <form action="<%= ctx %>/edit-service" method="POST" id="serviceForm">
                    <input type="hidden" name="id" value="<%= service.getId() %>">

                    <div class="form-group">
                        <label class="form-label" for="title">Service Title *</label>
                        <input type="text" id="title" name="title" class="form-control" value="<%= service.getTitle() %>" required>
                    </div>

                    <div class="grid grid-cols-2">
                        <div class="form-group">
                            <label class="form-label" for="categoryId">Category *</label>
                            <select id="categoryId" name="categoryId" class="form-select" required>
                                <% if (categories != null) { %>
                                    <% for (Category c : categories) { %>
                                        <option value="<%= c.getId() %>" <%= c.getId() == service.getCategoryId() ? "selected" : "" %>>
                                            <%= c.getName() %>
                                        </option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="price">Price (₹ INR) *</label>
                            <input type="number" id="price" name="price" class="form-control" value="<%= service.getPrice() %>" min="100" step="50" required>
                        </div>
                    </div>

                    <div class="grid grid-cols-2">
                        <div class="form-group">
                            <label class="form-label" for="deliveryDays">Delivery Time (Days) *</label>
                            <input type="number" id="deliveryDays" name="deliveryDays" class="form-control" value="<%= service.getDeliveryDays() %>" min="1" max="30" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="status">Listing Status *</label>
                            <select id="status" name="status" class="form-select" required>
                                <option value="ACTIVE" <%= "ACTIVE".equalsIgnoreCase(service.getStatus()) ? "selected" : "" %>>Active (Visible on Marketplace)</option>
                                <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(service.getStatus()) ? "selected" : "" %>>Inactive (Paused)</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <div style="display: flex; justify-content: space-between;">
                            <label class="form-label" for="description">Service Description *</label>
                            <span id="editDescCounter" class="form-hint">0 / 800</span>
                        </div>
                        <textarea id="description" name="description" class="form-control" rows="5" maxlength="800" data-char-counter="editDescCounter" required><%= service.getDescription() %></textarea>
                    </div>

                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <button type="submit" class="btn btn-primary btn-lg" style="flex: 1;">Save Changes</button>
                        <a href="<%= ctx %>/my-services" class="btn btn-secondary btn-lg">Cancel</a>
                    </div>
                </form>
            </div>
        <% } %>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
