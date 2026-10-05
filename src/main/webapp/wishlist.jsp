<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="java.util.List" %>
<%
    List<Service> wishlistItems = (List<Service>) request.getAttribute("wishlistItems");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="margin-bottom: 2rem;">
            <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Saved Services</span>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0; display: flex; align-items: center; gap: 0.5rem;">
                My Wishlist
                <svg width="24" height="24" viewBox="0 0 24 24" fill="#ef4444" stroke="#ef4444" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
            </h1>
            <p style="color: var(--text-secondary); margin-top: 0.25rem;">
                Keep track of student services you plan to hire in the future.
            </p>
        </div>

        <% if (wishlistItems != null && !wishlistItems.isEmpty()) { %>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem;">
                <% for (Service s : wishlistItems) { %>
                    <div class="service-card" id="wishlist-card-<%= s.getId() %>">
                        <div class="service-card-body">
                            <div class="service-freelancer">
                                <div class="user-avatar" style="width: 36px; height: 36px;">
                                    <%= s.getFreelancerName().substring(0, 1) %>
                                </div>
                                <div class="service-freelancer-info">
                                    <h4><a href="<%= ctx %>/freelancer-profile?id=<%= s.getFreelancerId() %>"><%= s.getFreelancerName() %></a></h4>
                                    <span>@<%= s.getFreelancerUsername() %></span>
                                </div>
                            </div>

                            <span class="service-category-badge"><%= s.getCategoryName() %></span>
                            <h3 class="service-card-title">
                                <a href="<%= ctx %>/service-details?id=<%= s.getId() %>"><%= s.getTitle() %></a>
                            </h3>
                            <p class="service-card-desc"><%= s.getDescription() %></p>

                            <div class="service-rating" style="display: flex; align-items: center; gap: 0.35rem;">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                <span style="font-weight: 700; color: var(--text-primary);"><%= String.format("%.1f", s.getRating()) %></span>
                                <span class="count">(<%= s.getReviewCount() %> reviews)</span>
                            </div>

                            <div style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.35rem;">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                Delivery: <strong><%= s.getDeliveryDays() %> <%= s.getDeliveryDays() == 1 ? "day" : "days" %></strong>
                            </div>
                        </div>

                        <div class="service-card-footer">
                            <div class="service-price-block">
                                <span class="service-price-label">Starting at</span>
                                <span class="service-price-val"><%= s.getFormattedPrice() %></span>
                            </div>
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <button type="button" class="btn btn-danger btn-sm" onclick="removeFromWishlist(<%= s.getId() %>)">
                                    Remove
                                </button>
                                <a href="<%= ctx %>/checkout?serviceId=<%= s.getId() %>" class="btn btn-primary btn-sm">
                                    Hire Now
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="card" style="text-align: center; padding: 4rem 1.5rem;">
                <div style="width: 60px; height: 60px; background: #fee2e2; color: #ef4444; border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center; margin: 0 auto 1.25rem;">
                    <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                </div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">Your wishlist is empty</h3>
                <p style="color: var(--text-secondary); max-width: 420px; margin: 0 auto 1.5rem;">
                    Browse our student marketplace and save services to easily access and hire them later.
                </p>
                <a href="<%= ctx %>/services" class="btn btn-primary">Browse Services Now</a>
            </div>
        <% } %>
    </main>

    <script>
        function removeFromWishlist(serviceId) {
            const formData = new URLSearchParams();
            formData.append('serviceId', serviceId);

            fetch('<%= ctx %>/api/wishlist/toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                const card = document.getElementById(`wishlist-card-${serviceId}`);
                if (card) {
                    card.style.opacity = '0';
                    card.style.transform = 'scale(0.9)';
                    card.style.transition = 'all 0.3s ease';
                    setTimeout(() => {
                        card.remove();
                        const remaining = document.querySelectorAll('.service-card').length;
                        if (remaining === 0) {
                            window.location.reload();
                        }
                    }, 300);
                }
                showToast('Removed from wishlist.', 'info');
            })
            .catch(err => {
                showToast('Failed to remove item.', 'error');
            });
        }
    </script>

    <jsp:include page="footer.jsp"/>
</body>
</html>
