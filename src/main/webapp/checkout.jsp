<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="com.skillforge.model.User" %>
<%
    Service service = (Service) request.getAttribute("service");
    User freelancer = (User) request.getAttribute("freelancer");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem; max-width: 960px;">
        <div style="margin-bottom: 2rem;">
            <a href="<%= ctx %>/service-details?id=<%= service != null ? service.getId() : "" %>" style="font-size: 0.9rem; font-weight: 600; color: var(--text-muted);">&larr; Back to Service</a>
            <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.5rem 0 0;">
                Project Checkout &amp; Agreement
            </h1>
        </div>

        <% if (service != null) { %>
            <input type="hidden" id="checkoutServiceId" value="<%= service.getId() %>">

            <div class="grid" style="grid-template-columns: 1.6fr 1fr; gap: 2.5rem; align-items: flex-start;">
                <!-- Left Column: Requirements & Payment Method -->
                <div>
                    <form action="<%= ctx %>/payment" method="POST" id="checkoutForm">
                        <input type="hidden" name="serviceId" value="<%= service.getId() %>">

                        <!-- AJAX Availability Check Status -->
                        <div class="card" style="padding: 1.25rem; margin-bottom: 1.75rem; background: var(--bg-surface); display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <strong style="display: block; font-size: 0.95rem;">Service Availability:</strong>
                                <span style="font-size: 0.82rem; color: var(--text-secondary);">Real-time asynchronous availability status</span>
                            </div>
                            <div id="availabilityBadge">
                                <span class="badge badge-pending">Verifying via AJAX...</span>
                            </div>
                        </div>

                        <!-- Requirements Form -->
                        <div class="card" style="padding: 2rem; margin-bottom: 2rem;">
                            <h2 style="font-size: 1.25rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">
                                1. Project Requirements &amp; Instructions
                            </h2>
                            <p style="font-size: 0.88rem; color: var(--text-secondary); margin-bottom: 1.25rem;">
                                Please outline your goals, references, timelines, and deliverables for <%= freelancer != null ? freelancer.getName() : "the freelancer" %>.
                            </p>

                            <div class="form-group">
                                <div style="display: flex; justify-content: space-between;">
                                    <label class="form-label" for="requirements">Detailed Project Requirements *</label>
                                    <span id="reqCharCounter" class="form-hint">0 / 1000</span>
                                </div>
                                <textarea id="requirements" name="requirements" class="form-control" rows="5" maxlength="1000" data-char-counter="reqCharCounter"
                                          placeholder="e.g. Please develop a responsive portfolio website with 4 pages (Home, Projects, About, Contact). I will provide the image assets and brand colors..." required></textarea>
                            </div>
                        </div>

                        <!-- Payment Method Selector -->
                        <div class="card" style="padding: 2rem; margin-bottom: 2rem;">
                            <h2 style="font-size: 1.25rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">
                                2. Select Mock Payment Method
                            </h2>
                            <p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 1.25rem;">
                                All transactions on SkillForge are simulated for academic demonstration. No real currency will be deducted.
                            </p>

                            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                                <label class="card" style="padding: 1rem 1.25rem; cursor: pointer; display: flex; align-items: center; gap: 1rem;">
                                    <input type="radio" name="paymentMethod" value="UPI" checked>
                                    <div style="flex: 1;">
                                        <strong style="display: block; font-size: 0.95rem;">UPI (Google Pay, PhonePe, Paytm, BHIM)</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Instant virtual payment simulation via student VPA</span>
                                    </div>
                                    <div style="width: 36px; height: 36px; background: var(--bg-main); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect><line x1="12" y1="18" x2="12.01" y2="18"></line></svg>
                                    </div>
                                </label>

                                <label class="card" style="padding: 1rem 1.25rem; cursor: pointer; display: flex; align-items: center; gap: 1rem;">
                                    <input type="radio" name="paymentMethod" value="Credit/Debit Card">
                                    <div style="flex: 1;">
                                        <strong style="display: block; font-size: 0.95rem;">Credit / Debit Card (Visa, RuPay, MasterCard)</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Simulated card processing with test credentials</span>
                                    </div>
                                    <div style="width: 36px; height: 36px; background: var(--bg-main); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                                    </div>
                                </label>

                                <label class="card" style="padding: 1rem 1.25rem; cursor: pointer; display: flex; align-items: center; gap: 1rem;">
                                    <input type="radio" name="paymentMethod" value="Offline Payment">
                                    <div style="flex: 1;">
                                        <strong style="display: block; font-size: 0.95rem;">Campus Offline Handover / Cash</strong>
                                        <span style="font-size: 0.8rem; color: var(--text-secondary);">Pay in-person directly at university premises upon inspection</span>
                                    </div>
                                    <div style="width: 36px; height: 36px; background: var(--bg-main); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <button type="submit" id="payButton" class="btn btn-primary btn-block btn-lg">
                            Confirm &amp; Complete Mock Payment &rarr;
                        </button>
                    </form>
                </div>

                <!-- Right Column: Order Summary Card -->
                <div style="position: sticky; top: 96px;">
                    <div class="card" style="padding: 1.75rem;">
                        <h3 style="font-size: 1.2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.25rem;">
                            Order Summary
                        </h3>

                        <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1.25rem; padding-bottom: 1.25rem; border-bottom: 1px solid var(--border);">
                            <div class="user-avatar" style="width: 44px; height: 44px; font-size: 1.1rem;">
                                <%= service.getFreelancerName().substring(0, 1) %>
                            </div>
                            <div>
                                <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--text-primary);"><%= service.getTitle() %></h4>
                                <span style="font-size: 0.82rem; color: var(--text-muted);">by <%= service.getFreelancerName() %></span>
                            </div>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 0.75rem; font-size: 0.9rem; margin-bottom: 1.5rem;">
                            <div style="display: flex; justify-content: space-between;">
                                <span style="color: var(--text-secondary);">Base Service Price:</span>
                                <strong><%= service.getFormattedPrice() %></strong>
                            </div>
                            <div style="display: flex; justify-content: space-between;">
                                <span style="color: var(--text-secondary);">Platform Service Fee:</span>
                                <span style="color: var(--success); font-weight: 700;">₹0 (Student Waiver)</span>
                            </div>
                            <div style="display: flex; justify-content: space-between;">
                                <span style="color: var(--text-secondary);">Estimated Delivery:</span>
                                <strong><%= service.getDeliveryDays() %> Days</strong>
                            </div>
                            <div style="display: flex; justify-content: space-between; padding-top: 0.75rem; border-top: 1px solid var(--border); font-size: 1.15rem; font-weight: 800;">
                                <span>Total Due:</span>
                                <span style="color: var(--primary);"><%= service.getFormattedPrice() %></span>
                            </div>
                        </div>

                        <div style="background-color: var(--primary-light); color: var(--primary-dark); padding: 0.85rem; border-radius: var(--radius-md); font-size: 0.8rem; line-height: 1.4; display: flex; gap: 0.5rem; align-items: flex-start;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink: 0; margin-top: 2px;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                            <div><strong>SkillForge Student Guarantee:</strong> Your mock payment generates a simulated transaction receipt and securely notifies the student freelancer to commence work.</div>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
