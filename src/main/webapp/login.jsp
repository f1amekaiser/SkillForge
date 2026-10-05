<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% String rememberedUser=(String) request.getAttribute("rememberedUsername"); if (rememberedUser==null) { Cookie[]
        cookies=request.getCookies(); if (cookies !=null) { for (Cookie c : cookies) { if
        ("rememberUser".equals(c.getName())) { rememberedUser=c.getValue(); break; } } } } String error=(String)
        request.getAttribute("error"); String redirect=request.getParameter("redirect"); String
        ctx=request.getContextPath(); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Log In - SkillForge</title>
            <link rel="stylesheet" href="<%= ctx %>/css/style.css">
        </head>

        <body>
            <jsp:include page="navbar.jsp" />

            <main class="container"
                style="display: flex; align-items: center; justify-content: center; min-height: 75vh; padding: 2.5rem 1rem;">
                <div class="card" style="max-width: 440px; width: 100%; padding: 2.5rem;">
                    <div style="text-align: center; margin-bottom: 2rem;">
                        <div class="brand-badge"
                            style="margin: 0 auto 1rem; width: 48px; height: 48px; font-size: 1.25rem;">SF</div>
                        <h1
                            style="font-size: 1.75rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.35rem;">
                            Welcome Back</h1>
                        <p style="font-size: 0.9rem; color: var(--text-secondary);">Log in to your SkillForge account
                        </p>
                    </div>

                    <% if (error !=null) { %>
                        <div
                            style="background-color: var(--danger-light); color: var(--danger); padding: 0.75rem 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; font-size: 0.88rem; font-weight: 600; border-left: 4px solid var(--danger);">
                            <%= error %>
                        </div>
                        <% } %>

                            <form action="<%= ctx %>/login" method="POST" id="loginForm">
                                <% if (redirect !=null) { %>
                                    <input type="hidden" name="redirect" value="<%= redirect %>">
                                    <% } %>

                                        <div class="form-group">
                                            <label class="form-label" for="usernameOrEmail">Username or Email</label>
                                            <input type="text" id="usernameOrEmail" name="usernameOrEmail"
                                                class="form-control" placeholder="e.g. aditya_dev or admin"
                                                value="<%= rememberedUser != null ? rememberedUser : "" %>" required>
                                        </div>

                                        <div class="form-group">
                                            <div
                                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.4rem;">
                                                <label class="form-label" for="password"
                                                    style="margin-bottom: 0;">Password</label>
                                            </div>
                                            <input type="password" id="password" name="password" class="form-control"
                                                placeholder="••••••••" required>
                                        </div>

                                        <div class="form-group"
                                            style="display: flex; align-items: center; justify-content: space-between;">
                                            <label
                                                style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.88rem; color: var(--text-secondary); cursor: pointer;">
                                                <input type="checkbox" name="rememberMe" value="true" <%=rememberedUser
                                                    !=null ? "checked" : "" %>>
                                                Remember Me
                                            </label>
                                        </div>

                                        <button type="submit" class="btn btn-primary btn-block btn-lg"
                                            style="margin-top: 1rem;">
                                            Sign In
                                        </button>
                            </form>

                            <!-- Quick Demo Credentials for Grading -->
                            <div
                                style="margin-top: 2rem; padding: 1.25rem; background-color: var(--bg-subtle); border-radius: var(--radius-md); border: 1px dashed var(--border);">
                                <div
                                    style="font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.35rem;">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                                        style="color: var(--primary);">
                                        <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" />
                                    </svg>
                                    Quick Test Credentials:
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 0.6rem; font-size: 0.82rem;">
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <span style="display: inline-flex; align-items: center; gap: 0.35rem;"><svg
                                                width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                stroke-linejoin="round" style="color: #f59e0b;">
                                                <path d="M2 4l3 12h14l3-12-6 7-4-7-4 7-6-7zm3 16h14" />
                                            </svg> <strong>Admin:</strong> admin</span>
                                        <code
                                            style="font-family: var(--font-mono); background: var(--bg-card); padding: 2px 6px; border-radius: 4px; border: 1px solid var(--border);">Admin@123</code>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <span style="display: inline-flex; align-items: center; gap: 0.35rem;"><svg
                                                width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                stroke-linejoin="round" style="color: #6366f1;">
                                                <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
                                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                            </svg> <strong>Freelancer:</strong> aditya_dev</span>
                                        <code
                                            style="font-family: var(--font-mono); background: var(--bg-card); padding: 2px 6px; border-radius: 4px; border: 1px solid var(--border);">Password@123</code>
                                    </div>
                                </div>
                            </div>

                            <div
                                style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-secondary);">
                                Don't have an account? <a href="<%= ctx %>/register.jsp"
                                    style="font-weight: 600;">Create an account</a>
                            </div>
                </div>
            </main>

            <jsp:include page="footer.jsp" />
        </body>

        </html>