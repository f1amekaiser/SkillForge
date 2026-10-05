<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.dao.ServiceDAO" %>
<%@ page import="com.skillforge.dao.CategoryDAO" %>
<%@ page import="com.skillforge.dao.UserDAO" %>
<%@ page import="com.skillforge.model.Service" %>
<%@ page import="com.skillforge.model.Category" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="java.util.List" %>
<%
    ServiceDAO serviceDAO = new ServiceDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    UserDAO userDAO = new UserDAO();

    List<Service> featuredServices = serviceDAO.getFeaturedServices(4);
    List<Category> categories = categoryDAO.getAllCategories();
    List<User> topFreelancers = userDAO.getUsersByRole("FREELANCER");
    if (topFreelancers.size() > 4) topFreelancers = topFreelancers.subList(0, 4);
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="SkillForge - Student freelancing and service marketplace connecting talented university students with clients.">
    <title>SkillForge | Forge Your Skills. Build Your Future.</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main>
        <!-- 1. Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="hero-tag">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px;">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                    </svg>
                    College Student Freelancing &amp; Service Marketplace
                </div>
                <h1>Forge Your Skills.<br><span>Build Your Future.</span></h1>
                <p>SkillForge connects talented students with people looking for affordable, reliable digital services. From full-stack web applications to AI pipelines and graphic design.</p>
                <div class="hero-cta">
                    <a href="<%= ctx %>/services" class="btn btn-primary btn-lg">Explore Services</a>
                    <a href="<%= ctx %>/register.jsp?role=FREELANCER" class="btn btn-secondary btn-lg">Start Freelancing</a>
                </div>

            </div>
        </section>

        <!-- 2. Popular Categories (Vector Graphic Icons & Balanced Grid) -->
        <section style="padding: 4rem 0;">
            <div class="container">
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
                    <div>
                        <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">Browse by Domain</span>
                        <h2 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-top: 0.25rem;">Popular Categories</h2>
                    </div>
                    <a href="<%= ctx %>/categories" style="font-weight: 600; font-size: 0.95rem;">View All Categories &rarr;</a>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 1.25rem;">
                    <% for (Category c : categories) { %>
                        <a href="<%= ctx %>/services?category=<%= c.getId() %>" class="card" style="text-decoration: none; color: inherit; padding: 1.5rem; text-align: center; border-radius: var(--radius-lg); transition: var(--transition); display: flex; flex-direction: column; justify-content: space-between;">
                            <div>
                                <div style="width: 52px; height: 52px; background: var(--primary-light); color: var(--primary); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                                    <% if (c.getName().toLowerCase().contains("web") || c.getName().toLowerCase().contains("app") || c.getName().toLowerCase().contains("code")) { %>
                                        <!-- Code / Dev Icon -->
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="16 18 22 12 16 6"></polyline>
                                            <polyline points="8 6 2 12 8 18"></polyline>
                                        </svg>
                                    <% } else if (c.getName().toLowerCase().contains("design") || c.getName().toLowerCase().contains("graphic") || c.getName().toLowerCase().contains("ui")) { %>
                                        <!-- Design / Palette Icon -->
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="13.5" cy="6.5" r=".5" fill="currentColor"></circle>
                                            <circle cx="17.5" cy="10.5" r=".5" fill="currentColor"></circle>
                                            <circle cx="8.5" cy="7.5" r=".5" fill="currentColor"></circle>
                                            <circle cx="6.5" cy="12.5" r=".5" fill="currentColor"></circle>
                                            <path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10c.926 0 1.648-.746 1.648-1.688 0-.437-.18-.835-.437-1.125-.29-.289-.438-.652-.438-1.125a1.64 1.64 0 0 1 1.668-1.668h1.996c3.051 0 5.555-2.503 5.555-5.554C21.965 6.012 17.461 2 12 2z"></path>
                                        </svg>
                                    <% } else if (c.getName().toLowerCase().contains("video") || c.getName().toLowerCase().contains("media")) { %>
                                        <!-- Video / Camera Icon -->
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <polygon points="23 7 16 12 23 17 23 7"></polygon>
                                            <rect x="1" y="5" width="15" height="14" rx="2" ry="2"></rect>
                                        </svg>
                                    <% } else if (c.getName().toLowerCase().contains("ai") || c.getName().toLowerCase().contains("data") || c.getName().toLowerCase().contains("science")) { %>
                                        <!-- CPU / Chip Icon -->
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect>
                                            <rect x="9" y="9" width="6" height="6"></rect>
                                            <line x1="9" y1="1" x2="9" y2="4"></line>
                                            <line x1="15" y1="1" x2="15" y2="4"></line>
                                            <line x1="9" y1="20" x2="9" y2="23"></line>
                                            <line x1="15" y1="20" x2="15" y2="23"></line>
                                            <line x1="20" y1="9" x2="23" y2="9"></line>
                                            <line x1="20" y1="14" x2="23" y2="14"></line>
                                            <line x1="1" y1="9" x2="4" y2="9"></line>
                                            <line x1="1" y1="14" x2="4" y2="14"></line>
                                        </svg>
                                    <% } else { %>
                                        <!-- Content / Education Icon -->
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                            <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                                        </svg>
                                    <% } %>
                                </div>
                                <h3 style="font-size: 1.05rem; font-weight: 700; margin-bottom: 0.35rem;"><%= c.getName() %></h3>
                                <p style="font-size: 0.82rem; color: var(--text-secondary); margin-bottom: 0.75rem;"><%= c.getDescription() %></p>
                            </div>
                            <div>
                                <span class="badge badge-accepted" style="font-size: 0.75rem;"><%= c.getServiceCount() %> Services</span>
                            </div>
                        </a>
                    <% } %>
                </div>
            </div>
        </section>

        <!-- 3. Featured Services (Dynamic Slots per Freelancer) -->
        <section style="padding: 4rem 0; background-color: var(--bg-subtle);">
            <div class="container">
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
                    <div>
                        <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">Curated Student Talent</span>
                        <h2 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-top: 0.25rem;">Featured Services</h2>
                    </div>
                    <a href="<%= ctx %>/services" style="font-weight: 600; font-size: 0.95rem;">Browse Full Marketplace &rarr;</a>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, <%= featuredServices.size() > 1 ? "1fr" : "360px" %>)); gap: 1.5rem;">
                    <% for (Service s : featuredServices) { %>
                        <div class="service-card">
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
                                    <button class="wishlist-btn-heart" onclick="toggleWishlist(<%= s.getId() %>, this)" title="Add to Wishlist" style="display: flex; align-items: center; justify-content: center;">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    </button>
                                    <a href="<%= ctx %>/service-details?id=<%= s.getId() %>" class="btn btn-primary btn-sm">View Service</a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </section>

        <!-- 4. Top Freelancers (Dynamic Slots - Expands as more freelancers register) -->
        <section style="padding: 4rem 0;">
            <div class="container">
                <div style="text-align: center; max-width: 600px; margin: 0 auto 3rem;">
                    <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">Campus Innovators</span>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-top: 0.25rem;">Meet Top Student Freelancers</h2>
                    <p style="color: var(--text-secondary); margin-top: 0.5rem;">Verified undergrads delivering agency-quality software, design, and analytics.</p>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, <%= topFreelancers.size() > 1 ? "1fr" : "340px" %>)); gap: 1.5rem; justify-content: center;">
                    <% for (User f : topFreelancers) { %>
                        <div class="card" style="text-align: center; padding: 2rem 1.5rem;">
                            <div class="user-avatar" style="width: 72px; height: 72px; font-size: 1.75rem; margin: 0 auto 1.25rem; border: 3px solid var(--primary-light);">
                                <%= f.getName().substring(0, 1) %>
                            </div>
                            <h3 style="font-size: 1.15rem; font-weight: 800; margin-bottom: 0.25rem;"><%= f.getName() %></h3>
                            <span style="font-size: 0.8rem; color: var(--text-muted); display: block; margin-bottom: 0.75rem;">@<%= f.getUsername() %></span>
                            <p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 1.25rem; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                <%= f.getBio() %>
                            </p>
                            <a href="<%= ctx %>/freelancer-profile?id=<%= f.getId() %>" class="btn btn-outline btn-sm btn-block">View Profile</a>
                        </div>
                    <% } %>
                </div>
            </div>
        </section>

        <!-- 5. How SkillForge Works (Vector Graphic Icons) -->
        <section style="padding: 4rem 0; background: linear-gradient(180deg, var(--bg-main), #ffffff);">
            <div class="container">
                <div style="text-align: center; max-width: 600px; margin: 0 auto 3rem;">
                    <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">E-Commerce Workflow</span>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-top: 0.25rem;">How SkillForge Works</h2>
                </div>

                <div class="grid grid-cols-4">
                    <div class="card" style="padding: 2rem 1.5rem; text-align: center;">
                        <div style="width: 48px; height: 48px; background: var(--primary-light); color: var(--primary); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                        </div>
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.5rem;">1. Browse Services</h3>
                        <p style="font-size: 0.85rem; color: var(--text-secondary);">Use our dynamic AJAX search to find matching student gigs and inspect verified credentials.</p>
                    </div>

                    <div class="card" style="padding: 2rem 1.5rem; text-align: center;">
                        <div style="width: 48px; height: 48px; background: var(--accent-light); color: var(--accent-hover); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                                <line x1="1" y1="10" x2="23" y2="10"></line>
                            </svg>
                        </div>
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.5rem;">2. Mock Checkout</h3>
                        <p style="font-size: 0.85rem; color: var(--text-secondary);">Select UPI, Card, or Offline mock payments to confirm order specs and generate a transaction ID.</p>
                    </div>

                    <div class="card" style="padding: 2rem 1.5rem; text-align: center;">
                        <div style="width: 48px; height: 48px; background: #ede9fe; color: #6d28d9; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"></path>
                                <path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"></path>
                            </svg>
                        </div>
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.5rem;">3. Track Delivery</h3>
                        <p style="font-size: 0.85rem; color: var(--text-secondary);">Follow the visual milestone tracker from Pending to Accepted, In Progress, and Delivered.</p>
                    </div>

                    <div class="card" style="padding: 2rem 1.5rem; text-align: center;">
                        <div style="width: 48px; height: 48px; background: var(--success-light); color: var(--success); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                            </svg>
                        </div>
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.5rem;">4. Rate &amp; Complete</h3>
                        <p style="font-size: 0.85rem; color: var(--text-secondary);">Approve deliverables and leave authentic reviews that bolster student portfolios.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 6. Why SkillForge? -->
        <section style="padding: 4rem 0;">
            <div class="container">
                <div class="grid grid-cols-2" style="align-items: center; gap: 3.5rem;">
                    <div>
                        <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">Why SkillForge?</span>
                        <h2 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin: 0.5rem 0 1.25rem; line-height: 1.25;">
                            Empowering College Students to Turn Coursework Into Real Income.
                        </h2>
                        <p style="color: var(--text-secondary); margin-bottom: 1.75rem; font-size: 1.05rem;">
                            University students possess cutting-edge skills in Java, Python, UI/UX, and multimedia. SkillForge gives them a safe, professional platform to showcase their craft and get hired.
                        </p>
                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <div style="display: flex; gap: 0.75rem; align-items: flex-start;">
                                <div style="color: var(--success); display: flex; align-items: center; justify-content: center; margin-top: 2px;">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h4 style="font-weight: 700; color: var(--text-primary);">Affordable Student Rates</h4>
                                    <p style="font-size: 0.85rem; color: var(--text-secondary);">Quality deliverables priced fairly for clubs, startups, and community clients.</p>
                                </div>
                            </div>
                            <div style="display: flex; gap: 0.75rem; align-items: flex-start;">
                                <div style="color: var(--success); display: flex; align-items: center; justify-content: center; margin-top: 2px;">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h4 style="font-weight: 700; color: var(--text-primary);">Zero Academic Plagiarism</h4>
                                    <p style="font-size: 0.85rem; color: var(--text-secondary);">Strict code of conduct ensuring genuine freelancing, software design, and tutoring.</p>
                                </div>
                            </div>
                            <div style="display: flex; gap: 0.75rem; align-items: flex-start;">
                                <div style="color: var(--success); display: flex; align-items: center; justify-content: center; margin-top: 2px;">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h4 style="font-weight: 700; color: var(--text-primary);">Real Experience for Resumes</h4>
                                    <p style="font-size: 0.85rem; color: var(--text-secondary);">Students graduate with real client testimonials and verifiable project work.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card" style="padding: 2.5rem; background: linear-gradient(135deg, #4f46e5, #06b6d4); color: white; border: none; box-shadow: var(--shadow-xl);">
                        <h3 style="font-size: 1.6rem; font-weight: 800; margin-bottom: 1rem;">Academic Technology Stack</h3>
                        <p style="font-size: 0.95rem; opacity: 0.9; margin-bottom: 1.5rem;">
                            SkillForge was engineered as an enterprise-grade academic demonstration for Web Technology, satisfying all Course Outcomes (CO1 to CO6).
                        </p>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; font-size: 0.85rem;">
                            <div style="background: rgba(255,255,255,0.15); padding: 0.75rem; border-radius: var(--radius-sm);">
                                <strong>Backend:</strong> Java Servlets
                            </div>
                            <div style="background: rgba(255,255,255,0.15); padding: 0.75rem; border-radius: var(--radius-sm);">
                                <strong>Dynamic View:</strong> JSP
                            </div>
                            <div style="background: rgba(255,255,255,0.15); padding: 0.75rem; border-radius: var(--radius-sm);">
                                <strong>Database:</strong> MySQL 8.0 / JDBC
                            </div>
                            <div style="background: rgba(255,255,255,0.15); padding: 0.75rem; border-radius: var(--radius-sm);">
                                <strong>Async:</strong> AJAX &amp; XML DOM
                            </div>
                        </div>
                        <div style="margin-top: 2rem;">
                            <a href="<%= ctx %>/xml-skills.jsp" class="btn btn-secondary btn-block" style="background: white; color: var(--primary) !important;">
                                Launch XML Skills Demonstration &rarr;
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 7. Call to Action -->
        <section style="padding: 5rem 0; text-align: center;">
            <div class="container">
                <div class="card" style="max-width: 800px; margin: 0 auto; padding: 3.5rem 2rem; background: linear-gradient(135deg, var(--bg-surface), #f8fafc); border-color: var(--primary);">
                    <h2 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1rem;">
                        Ready to Join SkillForge?
                    </h2>
                    <p style="font-size: 1.05rem; color: var(--text-secondary); max-width: 540px; margin: 0 auto 2rem;">
                        Whether you are a student freelancer offering services or an individual looking for skilled talent, get started today in under 2 minutes.
                    </p>
                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <a href="<%= ctx %>/register.jsp" class="btn btn-primary btn-lg">Create Free Account</a>
                        <a href="<%= ctx %>/services" class="btn btn-secondary btn-lg">Browse Marketplace</a>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
