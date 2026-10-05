<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Order" %>
<%@ page import="com.skillforge.model.Payment" %>
<%@ page import="com.skillforge.model.Review" %>
<%
    Order order = (Order) request.getAttribute("order");
    Payment payment = (Payment) request.getAttribute("payment");
    Review review = (Review) request.getAttribute("review");

    String userRole = (String) session.getAttribute("role");
    Integer currentUserId = (Integer) session.getAttribute("userId");
    String ctx = request.getContextPath();

    boolean isClient = (order != null && currentUserId != null && currentUserId.equals(order.getClientId()));
    boolean isFreelancer = (order != null && currentUserId != null && currentUserId.equals(order.getFreelancerId()));
    boolean isAdmin = "ADMIN".equalsIgnoreCase(userRole);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #<%= order != null ? order.getId() : "" %> Details - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem; max-width: 980px;">
        <% if (order != null) { %>
            <div style="margin-bottom: 2rem;">
                <a href="<%= isFreelancer ? ctx + "/incoming-orders" : (isAdmin ? ctx + "/admin/orders" : ctx + "/my-orders") %>" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Orders</a>
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-top: 0.5rem;">
                    <div>
                        <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0;">
                            Order #<%= order.getId() %>
                        </h1>
                        <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                            Placed on <%= order.getCreatedAt() %> • Service: <strong><%= order.getServiceTitle() %></strong>
                        </p>
                    </div>
                    <span class="badge badge-<%= order.getStatus().toLowerCase() %>" style="font-size: 0.95rem; padding: 0.4rem 1rem;">
                        <%= order.getStatus() %>
                    </span>
                </div>
            </div>

            <!-- Visual Progress Tracker -->
            <% if (!"CANCELLED".equalsIgnoreCase(order.getStatus())) { %>
                <div class="card" style="padding: 2rem; margin-bottom: 2rem;">
                    <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem; color: var(--text-primary);">
                        Project Progress Tracker
                    </h3>

                    <%
                        String st = order.getStatus().toUpperCase();
                        boolean s1 = true;
                        boolean s2 = "ACCEPTED".equals(st) || "IN_PROGRESS".equals(st) || "DELIVERED".equals(st) || "COMPLETED".equals(st);
                        boolean s3 = "IN_PROGRESS".equals(st) || "DELIVERED".equals(st) || "COMPLETED".equals(st);
                        boolean s4 = "DELIVERED".equals(st) || "COMPLETED".equals(st);
                        boolean s5 = "COMPLETED".equals(st);
                    %>

                    <div class="order-tracker">
                        <div class="tracker-step <%= s1 ? "completed" : "" %> <%= "PENDING".equals(st) ? "current" : "" %>">
                            <div class="tracker-circle">
                                <% if (s1 && !("PENDING".equals(st))) { %>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <% } else { %>
                                    1
                                <% } %>
                            </div>
                            <div class="tracker-label">Order Placed</div>
                        </div>

                        <div class="tracker-step <%= s2 ? "completed" : "" %> <%= "ACCEPTED".equals(st) ? "current" : "" %>">
                            <div class="tracker-circle">
                                <% if (s2 && !("ACCEPTED".equals(st))) { %>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <% } else { %>
                                    2
                                <% } %>
                            </div>
                            <div class="tracker-label">Accepted</div>
                        </div>

                        <div class="tracker-step <%= s3 ? "completed" : "" %> <%= "IN_PROGRESS".equals(st) ? "current" : "" %>">
                            <div class="tracker-circle">
                                <% if (s3 && !("IN_PROGRESS".equals(st))) { %>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <% } else { %>
                                    3
                                <% } %>
                            </div>
                            <div class="tracker-label">In Progress</div>
                        </div>

                        <div class="tracker-step <%= s4 ? "completed" : "" %> <%= "DELIVERED".equals(st) ? "current" : "" %>">
                            <div class="tracker-circle">
                                <% if (s4 && !("DELIVERED".equals(st))) { %>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <% } else { %>
                                    4
                                <% } %>
                            </div>
                            <div class="tracker-label">Delivered</div>
                        </div>

                        <div class="tracker-step <%= s5 ? "completed" : "" %> <%= "COMPLETED".equals(st) ? "current" : "" %>">
                            <div class="tracker-circle">
                                <% if (s5) { %>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <% } else { %>
                                    5
                                <% } %>
                            </div>
                            <div class="tracker-label">Completed</div>
                        </div>
                    </div>
                </div>
            <% } %>

            <!-- Order Core Information Grid -->
            <div class="grid grid-cols-2" style="margin-bottom: 2rem;">
                <!-- Left: Client & Freelancer info -->
                <div class="card" style="padding: 1.75rem;">
                    <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem; color: var(--text-primary);">Participants</h3>
                    <div style="display: flex; flex-direction: column; gap: 1rem; font-size: 0.9rem;">
                        <div>
                            <span style="color: var(--text-muted); font-size: 0.78rem; text-transform: uppercase; font-weight: 700;">Client:</span>
                            <div style="font-weight: 700; font-size: 1rem;"><%= order.getClientName() %></div>
                            <div style="color: var(--text-secondary);"><%= order.getClientEmail() %></div>
                        </div>
                        <div style="padding-top: 0.75rem; border-top: 1px solid var(--border);">
                            <span style="color: var(--text-muted); font-size: 0.78rem; text-transform: uppercase; font-weight: 700;">Student Freelancer:</span>
                            <div style="font-weight: 700; font-size: 1rem;"><%= order.getFreelancerName() %></div>
                            <div style="color: var(--text-secondary);"><%= order.getFreelancerEmail() %></div>
                        </div>
                    </div>
                </div>

                <!-- Right: Mock Payment Details -->
                <div class="card" style="padding: 1.75rem;">
                    <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem; color: var(--text-primary);">Transaction &amp; Escrow</h3>
                    <div style="display: flex; flex-direction: column; gap: 0.75rem; font-size: 0.9rem;">
                        <div style="display: flex; justify-content: space-between;">
                            <span style="color: var(--text-secondary);">Agreed Amount:</span>
                            <strong style="font-size: 1.1rem; color: var(--primary);"><%= order.getFormattedAmount() %></strong>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span style="color: var(--text-secondary);">Payment Method:</span>
                            <strong><%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "UPI" %></strong>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span style="color: var(--text-secondary);">Transaction ID:</span>
                            <code style="font-family: var(--font-mono); font-size: 0.82rem; background: var(--bg-subtle); padding: 0.2rem 0.4rem; border-radius: var(--radius-sm);">
                                <%= order.getTransactionId() != null ? order.getTransactionId() : "TXN_MOCK_PENDING" %>
                            </code>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span style="color: var(--text-secondary);">Escrow Status:</span>
                            <span class="badge badge-completed">Simulated Paid</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Project Requirements -->
            <div class="card" style="padding: 2rem; margin-bottom: 2rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 0.75rem; color: var(--text-primary);">Client Requirements</h3>
                <div style="background-color: var(--bg-subtle); padding: 1.25rem; border-radius: var(--radius-md); font-size: 0.95rem; line-height: 1.6; white-space: pre-line;">
                    <%= order.getRequirements() != null ? order.getRequirements() : "No specific requirements recorded." %>
                </div>
            </div>

            <!-- Delivery Message / Submission -->
            <% if (order.getDeliveryMessage() != null && !order.getDeliveryMessage().isEmpty()) { %>
                <div class="card" style="padding: 2rem; margin-bottom: 2rem; border-color: var(--accent);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                        <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
                            Freelancer's Deliverables
                        </h3>
                        <span class="badge badge-delivered">Delivered for Review</span>
                    </div>
                    <div style="background-color: var(--bg-subtle); padding: 1.25rem; border-radius: var(--radius-md); font-size: 0.95rem; line-height: 1.6; white-space: pre-line;">
                        <%= order.getDeliveryMessage() %>
                    </div>
                </div>
            <% } %>

            <!-- Workflow Action Controls -->
            <div class="card" style="padding: 2rem; margin-bottom: 2rem;">
                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1rem; color: var(--text-primary);">
                    Available Actions
                </h3>

                <!-- Freelancer Actions -->
                <% if (isFreelancer || isAdmin) { %>
                    <% if ("PENDING".equalsIgnoreCase(order.getStatus())) { %>
                        <div style="display: flex; gap: 1rem;">
                            <form action="<%= ctx %>/order/action" method="POST">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <input type="hidden" name="action" value="accept">
                                <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.35rem;">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    Accept Project
                                </button>
                            </form>
                            <form action="<%= ctx %>/order/action" method="POST">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <input type="hidden" name="action" value="cancel">
                                <button type="submit" class="btn btn-danger" style="display: inline-flex; align-items: center; gap: 0.35rem;">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                    Decline Project
                                </button>
                            </form>
                        </div>
                    <% } else if ("ACCEPTED".equalsIgnoreCase(order.getStatus())) { %>
                        <form action="<%= ctx %>/order/action" method="POST">
                            <input type="hidden" name="orderId" value="<%= order.getId() %>">
                            <input type="hidden" name="action" value="start">
                            <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polygon points="10 8 16 12 10 16 10 8"></polygon></svg>
                                Start Working (Mark In Progress)
                            </button>
                        </form>
                    <% } else if ("IN_PROGRESS".equalsIgnoreCase(order.getStatus())) { %>
                        <form action="<%= ctx %>/order/action" method="POST">
                            <input type="hidden" name="orderId" value="<%= order.getId() %>">
                            <input type="hidden" name="action" value="deliver">
                            <div class="form-group">
                                <label class="form-label" for="deliveryMessage">Deliverable Notes / Repository Link / Drive URL *</label>
                                <textarea id="deliveryMessage" name="deliveryMessage" class="form-control" rows="3"
                                          placeholder="e.g. Completed project files pushed to GitHub link: https://github.com/example/repo or Google Drive link..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                                Submit Completed Work
                            </button>
                        </form>
                    <% } %>
                <% } %>

                <!-- Client Actions -->
                <% if (isClient || isAdmin) { %>
                    <% if ("DELIVERED".equalsIgnoreCase(order.getStatus())) { %>
                        <div style="display: flex; gap: 1rem; align-items: center;">
                            <form action="<%= ctx %>/order/action" method="POST">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <input type="hidden" name="action" value="complete">
                                <button type="submit" class="btn btn-success btn-lg" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    Approve &amp; Complete Order
                                </button>
                            </form>
                            <span style="font-size: 0.85rem; color: var(--text-muted);">
                                Approving marks project complete and releases funds to the student freelancer.
                            </span>
                        </div>
                    <% } else if ("COMPLETED".equalsIgnoreCase(order.getStatus())) { %>
                        <% if (!order.isReviewed()) { %>
                            <a href="<%= ctx %>/review?orderId=<%= order.getId() %>" class="btn btn-primary btn-lg" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                Leave a Review &amp; Rating for <%= order.getFreelancerName() %>
                            </a>
                        <% } else { %>
                            <div style="display: flex; align-items: center; gap: 0.5rem; color: var(--success); font-weight: 700;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                You have reviewed this project. Thank you for supporting student talent!
                            </div>
                        <% } %>
                    <% } %>
                <% } %>
            </div>

            <!-- Existing Review Display if present -->
            <% if (review != null) { %>
                <div class="card" style="padding: 2rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--text-primary);">Project Review</h3>
                        <div style="color: #f59e0b; font-weight: 700; font-size: 1.1rem; display: flex; align-items: center; gap: 0.35rem;">
                            <%= review.getStarsSvg() %>
                            <span style="color: var(--text-primary); font-size: 0.9rem;">(<%= review.getRating() %>/5)</span>
                        </div>
                    </div>
                    <p style="font-size: 0.95rem; color: var(--text-secondary); line-height: 1.6;">
                        "<%= review.getComment() %>"
                    </p>
                    <span style="font-size: 0.8rem; color: var(--text-muted); display: block; margin-top: 0.5rem;">
                        Posted by <%= review.getClientName() %> on <%= review.getCreatedAt() %>
                    </span>
                </div>
            <% } %>
        <% } %>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
