<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Order" %>
<%
    Order order = (Order) request.getAttribute("order");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Freelancer - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem; max-width: 640px;">
        <% if (order != null) { %>
            <div class="card" style="padding: 2.5rem;">
                <div style="text-align: center; margin-bottom: 2rem;">
                    <div style="width: 60px; height: 60px; background: #fef3c7; color: #f59e0b; border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    </div>
                    <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.25rem;">
                        Review <%= order.getFreelancerName() %>
                    </h1>
                    <p style="color: var(--text-secondary); font-size: 0.95rem;">
                        For completing: <strong><%= order.getServiceTitle() %></strong> (Order #<%= order.getId() %>)
                    </p>
                </div>

                <form action="<%= ctx %>/review" method="POST" id="reviewForm">
                    <input type="hidden" name="orderId" value="<%= order.getId() %>">

                    <!-- Rating Radio selection -->
                    <div class="form-group" style="text-align: center;">
                        <label class="form-label" style="font-size: 1.05rem; margin-bottom: 0.75rem;">Your Rating</label>
                        <div style="display: flex; justify-content: center; gap: 1.5rem; font-size: 1.5rem;">
                            <label style="cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 0.25rem;">
                                <input type="radio" name="rating" value="5" checked>
                                <span style="font-size: 0.82rem; font-weight: 700; color: #f59e0b;">5 Stars</span>
                            </label>
                            <label style="cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 0.25rem;">
                                <input type="radio" name="rating" value="4">
                                <span style="font-size: 0.82rem; font-weight: 700; color: #f59e0b;">4 Stars</span>
                            </label>
                            <label style="cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 0.25rem;">
                                <input type="radio" name="rating" value="3">
                                <span style="font-size: 0.82rem; font-weight: 700; color: #f59e0b;">3 Stars</span>
                            </label>
                            <label style="cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 0.25rem;">
                                <input type="radio" name="rating" value="2">
                                <span style="font-size: 0.82rem; font-weight: 700; color: #f59e0b;">2 Stars</span>
                            </label>
                            <label style="cursor: pointer; display: flex; flex-direction: column; align-items: center; gap: 0.25rem;">
                                <input type="radio" name="rating" value="1">
                                <span style="font-size: 0.82rem; font-weight: 700; color: #f59e0b;">1 Star</span>
                            </label>
                        </div>
                    </div>

                    <!-- Feedback Comment -->
                    <div class="form-group" style="margin-top: 1.5rem;">
                        <div style="display: flex; justify-content: space-between;">
                            <label class="form-label" for="comment">Your Written Feedback &amp; Testimonial *</label>
                            <span id="reviewCharCounter" class="form-hint">0 / 500</span>
                        </div>
                        <textarea id="comment" name="comment" class="form-control" rows="4" maxlength="500" data-char-counter="reviewCharCounter"
                                  placeholder="Share your experience working with this student freelancer. Did they deliver on time? Was the code/design high quality?" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 1rem;">
                        Submit Verified Review
                    </button>
                    <a href="<%= ctx %>/order-details?id=<%= order.getId() %>" class="btn btn-secondary btn-block" style="margin-top: 0.5rem;">
                        Cancel
                    </a>
                </form>
            </div>
        <% } %>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
