<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.dao.SkillDAO" %>
<%@ page import="com.skillforge.model.Skill" %>
<%@ page import="java.util.List" %>
<%
    SkillDAO skillDAO = new SkillDAO();
    List<Skill> availableSkills = skillDAO.getAllSkills();
    String error = (String) request.getAttribute("error");
    String requestedRole = request.getParameter("role");
    if (requestedRole == null) requestedRole = (String) request.getAttribute("role");
    if (requestedRole == null) requestedRole = "CLIENT";
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="display: flex; align-items: center; justify-content: center; min-height: 85vh; padding: 3rem 1rem;">
        <div class="card" style="max-width: 600px; width: 100%; padding: 2.5rem;">
            <div style="text-align: center; margin-bottom: 2rem;">
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.35rem;">Create Your Account</h1>
                <p style="font-size: 0.9rem; color: var(--text-secondary);">Join SkillForge as a student freelancer or client</p>
            </div>

            <% if (error != null) { %>
                <div style="background-color: var(--danger-light); color: var(--danger); padding: 0.75rem 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; font-size: 0.88rem; font-weight: 600; border-left: 4px solid var(--danger);">
                    <%= error %>
                </div>
            <% } %>

            <form action="<%= ctx %>/register" method="POST" id="registerForm">
                <!-- Role Selection -->
                <div class="form-group">
                    <label class="form-label">I want to join as a:</label>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <label class="card" style="padding: 1rem; cursor: pointer; display: flex; align-items: center; gap: 0.75rem; border-color: <%= "CLIENT".equalsIgnoreCase(requestedRole) ? "var(--primary)" : "var(--border)" %>;">
                            <input type="radio" name="role" value="CLIENT" <%= "CLIENT".equalsIgnoreCase(requestedRole) ? "checked" : "" %> onchange="toggleSkillsSection()">
                            <div>
                                <strong style="display: block; font-size: 0.95rem;">Client / Buyer</strong>
                                <span style="font-size: 0.8rem; color: var(--text-secondary);">I want to hire student talent</span>
                            </div>
                        </label>
                        <label class="card" style="padding: 1rem; cursor: pointer; display: flex; align-items: center; gap: 0.75rem; border-color: <%= "FREELANCER".equalsIgnoreCase(requestedRole) ? "var(--primary)" : "var(--border)" %>;">
                            <input type="radio" name="role" value="FREELANCER" <%= "FREELANCER".equalsIgnoreCase(requestedRole) ? "checked" : "" %> onchange="toggleSkillsSection()">
                            <div>
                                <strong style="display: block; font-size: 0.95rem;">Student Freelancer</strong>
                                <span style="font-size: 0.8rem; color: var(--text-secondary);">I want to offer my services</span>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="name">Full Name *</label>
                        <input type="text" id="name" name="name" class="form-control" placeholder="e.g. Aditya S" required>
                    </div>

                    <!-- AJAX Feature 1: Live Username Check -->
                    <div class="form-group">
                        <label class="form-label" for="username">Username *</label>
                        <input type="text" id="username" name="username" class="form-control" placeholder="e.g. aditya_dev" required>
                        <span id="usernameStatus" class="form-hint" style="font-size: 0.82rem; transition: var(--transition);">
                            Type to check live availability via AJAX
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="aditya@example.com" required>
                </div>

                <div class="grid grid-cols-2">
                    <div class="form-group">
                        <label class="form-label" for="regPassword">Password *</label>
                        <input type="password" id="regPassword" name="password" class="form-control" placeholder="At least 6 characters" required>
                        <!-- Password Strength Indicator -->
                        <div style="height: 4px; background: #e2e8f0; border-radius: 2px; margin-top: 6px; overflow: hidden;">
                            <div id="passwordStrengthBar" style="height: 100%; width: 0%; transition: var(--transition);"></div>
                        </div>
                        <div id="passwordStrengthLabel" style="font-size: 0.75rem; margin-top: 3px; font-weight: 600;"></div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Re-enter password" required>
                    </div>
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between;">
                        <label class="form-label" for="bio">Bio / Professional Headline</label>
                        <span id="bioCharCounter" class="form-hint">0 / 300</span>
                    </div>
                    <textarea id="bio" name="bio" class="form-control" rows="2" maxlength="300" data-char-counter="bioCharCounter"
                              placeholder="e.g. 3rd year CS undergrad passionate about Java, web applications, and UI/UX design."></textarea>
                </div>

                <!-- Freelancer Skills Selector -->
                <div id="skillsSection" style="display: <%= "FREELANCER".equalsIgnoreCase(requestedRole) ? "block" : "none" %>; margin-bottom: 1.5rem;">
                    <label class="form-label">Select Your Skills:</label>
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.5rem; max-height: 160px; overflow-y: auto; padding: 0.5rem; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--bg-subtle);">
                        <% for (Skill s : availableSkills) { %>
                            <label style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; cursor: pointer;">
                                <input type="checkbox" name="skills" value="<%= s.getId() %>">
                                <span><%= s.getName() %></span>
                            </label>
                        <% } %>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 1rem;">
                    Create SkillForge Account
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-secondary);">
                Already registered? <a href="<%= ctx %>/login.jsp" style="font-weight: 600;">Log in here</a>
            </div>
        </div>
    </main>

    <script>
        function toggleSkillsSection() {
            const roleEl = document.querySelector('input[name="role"]:checked');
            const skillsSec = document.getElementById('skillsSection');
            if (roleEl && skillsSec) {
                skillsSec.style.display = roleEl.value === 'FREELANCER' ? 'block' : 'none';
            }
        }
    </script>

    <jsp:include page="footer.jsp"/>
</body>
</html>
