<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.dao.CategoryDAO" %>
<%@ page import="com.skillforge.model.Category" %>
<%@ page import="java.util.List" %>
<%
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categories = categoryDAO.getAllCategories();
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Categories - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem;">
        <div style="text-align: center; max-width: 650px; margin: 0 auto 3rem;">
            <span style="color: var(--primary); font-weight: 700; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;">Directory</span>
            <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--text-primary); margin-top: 0.25rem;">Browse Service Domains</h1>
            <p style="color: var(--text-secondary); margin-top: 0.5rem; font-size: 1.05rem;">
                Explore freelance gigs across diverse technological and creative categories offered by university students.
            </p>
        </div>

        <div class="grid grid-cols-3" style="gap: 2rem;">
            <% for (Category c : categories) { %>
                <div class="card" style="padding: 2rem; display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <div style="width: 56px; height: 56px; background-color: var(--primary-light); color: var(--primary); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; margin-bottom: 1.25rem;">
                            <% if (c.getName().toLowerCase().contains("web") || c.getName().toLowerCase().contains("app") || c.getName().toLowerCase().contains("code")) { %>
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="16 18 22 12 16 6"></polyline>
                                    <polyline points="8 6 2 12 8 18"></polyline>
                                </svg>
                            <% } else if (c.getName().toLowerCase().contains("design") || c.getName().toLowerCase().contains("graphic") || c.getName().toLowerCase().contains("ui")) { %>
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="13.5" cy="6.5" r=".5" fill="currentColor"></circle>
                                    <circle cx="17.5" cy="10.5" r=".5" fill="currentColor"></circle>
                                    <circle cx="8.5" cy="7.5" r=".5" fill="currentColor"></circle>
                                    <circle cx="6.5" cy="12.5" r=".5" fill="currentColor"></circle>
                                    <path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10c.926 0 1.648-.746 1.648-1.688 0-.437-.18-.835-.437-1.125-.29-.289-.438-.652-.438-1.125a1.64 1.64 0 0 1 1.668-1.668h1.996c3.051 0 5.555-2.503 5.555-5.554C21.965 6.012 17.461 2 12 2z"></path>
                                </svg>
                            <% } else if (c.getName().toLowerCase().contains("video") || c.getName().toLowerCase().contains("media")) { %>
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polygon points="23 7 16 12 23 17 23 7"></polygon>
                                    <rect x="1" y="5" width="15" height="14" rx="2" ry="2"></rect>
                                </svg>
                            <% } else if (c.getName().toLowerCase().contains("ai") || c.getName().toLowerCase().contains("data") || c.getName().toLowerCase().contains("science")) { %>
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                                </svg>
                            <% } %>
                        </div>
                        <h2 style="font-size: 1.35rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;"><%= c.getName() %></h2>
                        <p style="font-size: 0.92rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 1.5rem;">
                            <%= c.getDescription() %>
                        </p>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 1.25rem; border-top: 1px solid var(--border);">
                        <span class="badge badge-accepted"><%= c.getServiceCount() %> Available Gigs</span>
                        <a href="<%= ctx %>/services?category=<%= c.getId() %>" class="btn btn-outline btn-sm">Explore Category &rarr;</a>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
