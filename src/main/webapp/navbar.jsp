<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentRole = (String) session.getAttribute("role");
    String currentUsername = (String) session.getAttribute("username");
    String currentName = (String) session.getAttribute("name");
    Integer currentUserId = (Integer) session.getAttribute("userId");
    String ctx = request.getContextPath();
%>
<script>
    window.SKILLFORGE_CONTEXT = '<%= ctx %>';
</script>

<nav class="navbar">
    <div class="container nav-container">
        <a href="<%= ctx %>/" class="brand">
            <div class="brand-badge">SF</div>
            <div class="brand-text">SKILL<span>FORGE</span></div>
        </a>

        <!-- Clutter-Free Primary Navigation -->
        <ul class="nav-links">
            <li><a href="<%= ctx %>/">Home</a></li>
            <li><a href="<%= ctx %>/services">Explore Services</a></li>
            <li><a href="<%= ctx %>/categories">Categories</a></li>
            <li><a href="<%= ctx %>/xml-skills.jsp">XML Demo</a></li>
            <li><a href="<%= ctx %>/about.jsp">About</a></li>
        </ul>

        <!-- Right Side Actions & User Menu -->
        <div class="nav-actions">
            <% if (currentUserId == null) { %>
                <a href="<%= ctx %>/login.jsp" class="btn btn-outline btn-sm">Log In</a>
                <a href="<%= ctx %>/register.jsp" class="btn btn-primary btn-sm">Sign Up</a>
            <% } else { %>
                <% if ("FREELANCER".equalsIgnoreCase(currentRole)) { %>
                    <a href="<%= ctx %>/create-service" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 0.35rem;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        Post Gig
                    </a>
                <% } else if ("CLIENT".equalsIgnoreCase(currentRole)) { %>
                    <a href="<%= ctx %>/wishlist" class="btn-wishlist-nav" title="My Wishlist" style="position: relative; color: var(--text-secondary); text-decoration: none; padding: 0.45rem; border-radius: var(--radius-md); display: flex; align-items: center; border: 1px solid var(--border);">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                    </a>
                <% } %>

                <!-- User Profile Dropdown Menu -->
                <div class="nav-user-dropdown" id="navUserDropdown">
                    <button class="nav-user-btn" id="navUserBtn" type="button" aria-expanded="false" title="Account Menu">
                        <div class="user-avatar" style="width: 34px; height: 34px; font-size: 0.85rem;">
                            <%= currentName != null ? currentName.substring(0, 1).toUpperCase() : "U" %>
                        </div>
                        <div class="nav-user-meta">
                            <span class="nav-user-name"><%= currentName %></span>
                            <span class="nav-user-role"><%= currentRole %></span>
                        </div>
                        <svg class="dropdown-chevron" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>

                    <div class="nav-dropdown-menu" id="navDropdownMenu">
                        <div class="dropdown-header">
                            <div class="dropdown-user-name"><%= currentName %></div>
                            <div class="dropdown-user-username">@<%= currentUsername %></div>
                            <span class="dropdown-role-badge"><%= currentRole %></span>
                        </div>

                        <div class="dropdown-divider"></div>

                        <div class="dropdown-links">
                            <% if ("CLIENT".equalsIgnoreCase(currentRole)) { %>
                                <a href="<%= ctx %>/client-dashboard" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                                    Dashboard
                                </a>
                                <a href="<%= ctx %>/my-orders" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
                                    My Orders
                                </a>
                                <a href="<%= ctx %>/wishlist" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    Saved Wishlist
                                </a>
                                <a href="<%= ctx %>/client-profile" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                    Account Settings
                                </a>
                            <% } else if ("FREELANCER".equalsIgnoreCase(currentRole)) { %>
                                <a href="<%= ctx %>/freelancer-dashboard" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                                    Dashboard
                                </a>
                                <a href="<%= ctx %>/incoming-orders" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                    Incoming Orders
                                </a>
                                <a href="<%= ctx %>/my-services" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                                    My Services
                                </a>
                                <a href="<%= ctx %>/earnings" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                                    Earnings &amp; Payouts
                                </a>
                                <a href="<%= ctx %>/freelancer-profile?id=<%= currentUserId %>" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                    Public Profile
                                </a>
                                <a href="<%= ctx %>/freelancer-profile-edit" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                    Edit Profile
                                </a>
                            <% } else if ("ADMIN".equalsIgnoreCase(currentRole)) { %>
                                <a href="<%= ctx %>/admin-dashboard" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                                    Admin Dashboard
                                </a>
                                <a href="<%= ctx %>/admin/users" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path></svg>
                                    Manage Users
                                </a>
                                <a href="<%= ctx %>/admin/services" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                                    Manage Services
                                </a>
                                <a href="<%= ctx %>/admin/orders" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path><line x1="3" y1="6" x2="21" y2="6"></line></svg>
                                    Manage Orders
                                </a>
                                <a href="<%= ctx %>/admin/categories" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line></svg>
                                    Categories
                                </a>
                                <a href="<%= ctx %>/admin/payments" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                                    Payment Records
                                </a>
                            <% } %>
                        </div>

                        <div class="dropdown-divider"></div>

                        <a href="<%= ctx %>/logout" class="dropdown-item dropdown-item-danger">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                            Log Out
                        </a>
                    </div>
                </div>
            <% } %>

            <button class="mobile-menu-btn" aria-label="Toggle navigation">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
        </div>
    </div>
</nav>
