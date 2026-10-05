<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User" %>
<%@ page import="com.skillforge.model.Skill" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%
    User user = (User) request.getAttribute("user");
    List<Skill> allSkills = (List<Skill>) request.getAttribute("allSkills");
    List<Skill> userSkills = (List<Skill>) request.getAttribute("userSkills");
    Set<Integer> userSkillIds = new HashSet<>();
    if (userSkills != null) {
        for (Skill s : userSkills) userSkillIds.add(s.getId());
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Freelancer Profile &amp; Skills - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem; max-width: 680px;">
        <div class="card" style="padding: 2.5rem;">
            <div style="margin-bottom: 2rem;">
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Profile &amp; Skills</span>
                <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--text-primary); margin: 0.25rem 0 0;">
                    Manage Freelancer Identity
                </h1>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">
                    Update your public headline, university background, and technical skillset.
                </p>
            </div>

            <% if (user != null) { %>
                <form action="<%= ctx %>/freelancer-profile-edit" method="POST">
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" value="<%= user.getUsername() %>" disabled style="background-color: var(--bg-subtle);">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="name">Full Name *</label>
                        <input type="text" id="name" name="name" class="form-control" value="<%= user.getName() %>" required>
                    </div>

                    <div class="form-group">
                        <div style="display: flex; justify-content: space-between;">
                            <label class="form-label" for="bio">Bio &amp; Academic Background</label>
                            <span id="flBioCounter" class="form-hint">0 / 400</span>
                        </div>
                        <textarea id="bio" name="bio" class="form-control" rows="4" maxlength="400" data-char-counter="flBioCounter"
                                  placeholder="Describe your student journey, degree, strengths, and tools you excel with..."><%= user.getBio() != null ? user.getBio() : "" %></textarea>
                    </div>

                    <!-- Skills Checkboxes -->
                    <div class="form-group" style="margin-top: 1.5rem;">
                        <label class="form-label">Select Your Featured Skills:</label>
                        <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.6rem; max-height: 200px; overflow-y: auto; padding: 0.75rem; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--bg-subtle);">
                            <% if (allSkills != null) { %>
                                <% for (Skill s : allSkills) { %>
                                    <label style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.88rem; cursor: pointer;">
                                        <input type="checkbox" name="skills" value="<%= s.getId() %>" <%= userSkillIds.contains(s.getId()) ? "checked" : "" %>>
                                        <span><%= s.getName() %></span>
                                    </label>
                                <% } %>
                            <% } %>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Save Profile &amp; Skills</button>
                        <a href="<%= ctx %>/freelancer-dashboard" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            <% } %>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
