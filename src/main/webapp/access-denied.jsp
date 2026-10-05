<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - SkillForge</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="display: flex; align-items: center; justify-content: center; min-height: 60vh;">
        <div class="card" style="max-width: 520px; width: 100%; text-align: center; padding: 3rem 2rem;">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 72px; height: 72px; border-radius: 50%; background: #fee2e2; color: var(--danger); margin: 0 auto 1.5rem auto;">
                <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--danger); margin-bottom: 0.75rem;">
                Access Denied
            </h1>
            <p style="color: var(--text-secondary); margin-bottom: 2rem;">
                You do not have permission to access this protected area. Role-based access control (RBAC) ensures pages are restricted strictly to authorized Client, Freelancer, or Admin accounts.
            </p>
            <div style="display: flex; gap: 1rem; justify-content: center;">
                <a href="<%= request.getContextPath() %>/" class="btn btn-primary">Go to Home</a>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-secondary">Switch Account</a>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
