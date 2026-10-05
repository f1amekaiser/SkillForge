<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="com.skillforge.model.Review" %>
<%@ page import="com.skillforge.model.Skill" %>
<%@ page import="java.util.List" %>
<%
    Service service = (Service) request.getAttribute("service");
    User freelancer = (User) request.getAttribute("freelancer");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Boolean inWishlist = (Boolean) request.getAttribute("inWishlist");
    if (inWishlist == null) inWishlist = false;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= service != null ? service.getTitle() : "Service Details" %> - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <% if (service != null) { %>
            <div style="margin-bottom: 1.5rem;">
                <a href="<%= ctx %>/services" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Services</a>
            </div>

            <div class="grid" style="grid-template-columns: 2fr 1fr; gap: 2.5rem; align-items: flex-start;">
                <!-- Left Column: Details & Reviews -->
                <div>
                    <span class="service-category-badge"><%= service.getCategoryName() %></span>
                    <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.5rem 0 1rem; line-height: 1.25;">
                        <%= service.getTitle() %>
                    </h1>

                    <!-- Freelancer Header -->
                    <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 1px solid var(--border);">
                        <div class="user-avatar" style="width: 52px; height: 52px; font-size: 1.35rem;">
                            <%= service.getFreelancerName().substring(0, 1) %>
                        </div>
                        <div>
                            <div style="font-weight: 700; font-size: 1.05rem;">
                                <a href="<%= ctx %>/freelancer-profile?id=<%= service.getFreelancerId() %>"><%= service.getFreelancerName() %></a>
                            </div>
                            <div style="font-size: 0.85rem; color: var(--text-muted);">
                                @<%= service.getFreelancerUsername() %> • Final Year Student Specialist
                            </div>
                        </div>
                        <div style="margin-left: auto; display: flex; align-items: center; gap: 0.4rem; font-size: 1.05rem; font-weight: 800; color: #f59e0b;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <span><%= String.format("%.2f", service.getRating()) %></span>
                            <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 500;">(<%= service.getReviewCount() %> reviews)</span>
                        </div>
                    </div>

                    <!-- About Gig -->
                    <div class="card" style="margin-bottom: 2rem; padding: 2rem;">
                        <h2 style="font-size: 1.35rem; font-weight: 800; margin-bottom: 1rem; color: var(--text-primary);">About this Service</h2>
                        <div style="font-size: 1rem; line-height: 1.7; color: var(--text-secondary); white-space: pre-line;">
                            <%= service.getDescription() %>
                        </div>

                        <% if (service.getSkills() != null && !service.getSkills().isEmpty()) { %>
                            <div style="margin-top: 1.75rem; padding-top: 1.25rem; border-top: 1px solid var(--border);">
                                <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.6rem;">Associated Skills &amp; Technologies:</h4>
                                <div class="service-tags">
                                    <% for (Skill sk : service.getSkills()) { %>
                                        <span class="service-tag" style="font-size: 0.82rem; padding: 0.35rem 0.75rem;"><%= sk.getName() %></span>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <!-- Reviews Section -->
                    <div class="card" style="padding: 2rem;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                            <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary);">Verified Client Reviews</h2>
                            <div style="font-weight: 700; color: var(--text-primary);">
                                <%= reviews != null ? reviews.size() : 0 %> Feedbacks
                            </div>
                        </div>

                        <% if (reviews != null && !reviews.isEmpty()) { %>
                            <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                                <% for (Review r : reviews) { %>
                                    <div style="padding-bottom: 1.25rem; border-bottom: 1px solid var(--border);">
                                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                            <div style="display: flex; align-items: center; gap: 0.65rem;">
                                                <div class="user-avatar" style="width: 34px; height: 34px; font-size: 0.85rem;">
                                                    <%= r.getClientName().substring(0, 1) %>
                                                </div>
                                                <div style="font-weight: 700; font-size: 0.95rem;"><%= r.getClientName() %></div>
                                            </div>
                                            <div style="display: flex; align-items: center; gap: 0.25rem;">
                                                <%= r.getStarsSvg() %>
                                                <span style="font-size: 0.85rem; font-weight: 700; color: var(--text-primary); margin-left: 0.25rem;">(<%= r.getRating() %>/5)</span>
                                            </div>
                                        </div>
                                        <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.5; margin-left: 2.75rem;">
                                            <%= r.getComment() %>
                                        </p>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <p style="color: var(--text-muted); font-size: 0.95rem;">No reviews yet. Be the first client to complete an order and leave feedback!</p>
                        <% } %>
                    </div>
                </div>

                <!-- Right Column: Pricing & Checkout Box -->
                <div style="position: sticky; top: 96px;">
                    <div class="card" style="padding: 2rem; border-color: var(--primary);">
                        <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 1.5rem;">
                            <span style="font-size: 0.9rem; font-weight: 600; color: var(--text-secondary);">Standard Package</span>
                            <span style="font-size: 2rem; font-weight: 800; color: var(--text-primary);"><%= service.getFormattedPrice() %></span>
                        </div>

                        <div style="background-color: var(--bg-subtle); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; display: flex; flex-direction: column; gap: 0.75rem; font-size: 0.88rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    Delivery Time:
                                </span>
                                <strong><%= service.getDeliveryDays() %> <%= service.getDeliveryDays() == 1 ? "day" : "days" %></strong>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg>
                                    Revisions:
                                </span>
                                <strong>Unlimited</strong>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="display: flex; align-items: center; gap: 0.4rem;">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                                    Protection:
                                </span>
                                <strong>SkillForge Peer Escrow</strong>
                            </div>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 0.75rem; margin-bottom: 1.5rem;">
                            <a href="<%= ctx %>/checkout?serviceId=<%= service.getId() %>" class="btn btn-primary btn-block btn-lg">
                                Hire Now &rarr;
                            </a>

                            <button type="button" class="btn btn-secondary btn-block" onclick="toggleWishlist(<%= service.getId() %>, this)" style="display: flex; align-items: center; justify-content: center; gap: 0.4rem;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="<%= inWishlist ? "currentColor" : "none" %>" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                <span><%= inWishlist ? "Saved in Wishlist" : "Add to Wishlist" %></span>
                            </button>
                        </div>

                        <div style="font-size: 0.8rem; color: var(--text-muted); text-align: center; line-height: 1.5;">
                            100% Mock Payment System • Instant Order Generation • Direct Student Collaboration
                        </div>
                    </div>

                    <!-- Freelancer Card -->
                    <% if (freelancer != null) { %>
                        <div class="card" style="margin-top: 1.5rem; padding: 1.5rem; text-align: center;">
                            <div class="user-avatar" style="width: 60px; height: 60px; font-size: 1.5rem; margin: 0 auto 0.75rem;">
                                <%= freelancer.getName().substring(0, 1) %>
                            </div>
                            <h3 style="font-size: 1.1rem; font-weight: 800;"><%= freelancer.getName() %></h3>
                            <span style="font-size: 0.82rem; color: var(--text-muted); display: block; margin-bottom: 0.75rem;">@<%= freelancer.getUsername() %></span>
                            <p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 1rem; line-height: 1.4;">
                                <%= freelancer.getBio() %>
                            </p>
                            <a href="<%= ctx %>/freelancer-profile?id=<%= freelancer.getId() %>" class="btn btn-outline btn-sm btn-block">
                                View Full Profile
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
