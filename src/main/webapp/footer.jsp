<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String footerCtx = request.getContextPath();
%>
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div>
                <div class="footer-brand">SKILL<span>FORGE</span></div>
                <p class="footer-desc">
                    "Forge your skills. Build your future."<br>
                    A student-focused freelancing and service marketplace bridging campus talent with digital opportunities.
                </p>
                <div style="font-size: 0.8rem; color: #64748b; line-height: 1.5;">
                    Built with Java Servlets, JSP, JDBC, MySQL, AJAX &amp; Vanilla CSS.<br>
                    Strict MVC Architecture &amp; DAO Pattern.
                </div>
            </div>

            <div class="footer-col">
                <h4>Marketplace</h4>
                <ul class="footer-links">
                    <li><a href="<%= footerCtx %>/services">Browse All Services</a></li>
                    <li><a href="<%= footerCtx %>/categories">Service Categories</a></li>
                    <li><a href="<%= footerCtx %>/services?sortBy=rating">Top Rated Students</a></li>
                    <li><a href="<%= footerCtx %>/xml-skills.jsp">XML Skills Registry</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Platform</h4>
                <ul class="footer-links">
                    <li><a href="<%= footerCtx %>/register.jsp?role=FREELANCER">Become a Freelancer</a></li>
                    <li><a href="<%= footerCtx %>/register.jsp?role=CLIENT">Hire Student Talent</a></li>
                    <li><a href="<%= footerCtx %>/about.jsp">Academic Outcomes (CO1-CO6)</a></li>
                    <li><a href="<%= footerCtx %>/login.jsp">Account Login</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Academic Project</h4>
                <ul class="footer-links">
                    <li><span style="color: #64748b;">Course: Web Technology</span></li>
                    <li><span style="color: #64748b;">Server: Apache Tomcat 11</span></li>
                    <li><span style="color: #64748b;">Database: MySQL 8.0</span></li>
                    <li><a href="<%= footerCtx %>/xml-skills.jsp" style="color: var(--accent);">Live XML AJAX Parsing →</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <div>&copy; 2026 SkillForge Inc. All rights reserved. Designed for Academic Demonstration.</div>
            <div style="display: flex; gap: 1.5rem;">
                <a href="<%= footerCtx %>/">Privacy</a>
                <a href="<%= footerCtx %>/">Terms of Service</a>
                <a href="<%= footerCtx %>/about.jsp">Testing &amp; Security</a>
            </div>
        </div>
    </div>
</footer>

<script src="<%= footerCtx %>/js/main.js"></script>
<script src="<%= footerCtx %>/js/validation.js"></script>
<script src="<%= footerCtx %>/js/ajax.js"></script>
<script src="<%= footerCtx %>/js/search.js"></script>
