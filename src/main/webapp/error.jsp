<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - SkillForge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="display: flex; align-items: center; justify-content: center; min-height: 60vh;">
        <div class="card" style="max-width: 520px; width: 100%; text-align: center; padding: 3rem 2rem;">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 72px; height: 72px; border-radius: 50%; background: #fef3c7; color: #d97706; margin: 0 auto 1.5rem auto;">
                <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            </div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.75rem;">
                Oops! Something Went Wrong
            </h1>
            <p style="color: var(--text-secondary); margin-bottom: 2rem;">
                <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "The requested page encountered an issue or could not be found. Please check the URL or return to home." %>
            </p>
            <div style="display: flex; gap: 1rem; justify-content: center;">
                <a href="<%= request.getContextPath() %>/" class="btn btn-primary">Return to Home</a>
                <a href="<%= request.getContextPath() %>/services" class="btn btn-secondary">Explore Services</a>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
