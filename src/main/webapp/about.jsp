<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About SkillForge - Academic Web Technology Project</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3.5rem 1.5rem; max-width: 960px;">
        <div style="text-align: center; margin-bottom: 3rem;">
            <div class="brand-badge" style="margin: 0 auto 1rem; width: 56px; height: 56px; font-size: 1.5rem;">SF</div>
            <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">About SkillForge</h1>
            <p style="font-size: 1.15rem; color: var(--primary); font-weight: 600;">"Forge your skills. Build your future."</p>
            <p style="color: var(--text-secondary); max-width: 650px; margin: 0.5rem auto 0;">
                A student-centric freelancing and digital service marketplace developed for the Web Technology course.
            </p>
        </div>

        <!-- Problem Statement & Objectives -->
        <div class="card" style="padding: 2.25rem; margin-bottom: 2rem;">
            <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1rem;">Problem Statement &amp; Vision</h2>
            <p style="color: var(--text-secondary); line-height: 1.7; margin-bottom: 1rem;">
                College students routinely develop high-value programming, design, writing, and analytical skills in their labs and coursework, yet struggle to find genuine entry-level freelancing opportunities or gain authentic client experience. Mainstream freelancing platforms are oversaturated with established agencies, imposing prohibitive entry barriers on students.
            </p>
            <p style="color: var(--text-secondary); line-height: 1.7;">
                <strong>SkillForge</strong> solves this by offering a curated peer-to-peer campus marketplace where university students can showcase their competencies, receive orders from campus clubs, local businesses, and community clients, accept mock payments, track deliverables, and receive verifiable peer reviews.
            </p>
        </div>

        <!-- 10 Core Concept Demonstrations -->
        <div class="card" style="padding: 2.25rem; margin-bottom: 2rem;">
            <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.25rem;">10 Demonstrated Web Technology Concepts</h2>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; font-size: 0.9rem;">
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>1. Client-Side Scripting:</strong> Vanilla JavaScript form validations, password strength bar, dynamic counters.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>2. Java Servlets:</strong> Controller layer routing GET/POST requests, session creation, data passing.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>3. JSP Dynamic Pages:</strong> Dynamic view generation using clean scriptlets and expressions without SQL queries.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>4. Cookies &amp; Sessions:</strong> Remember Me cookie (<code>rememberUser</code>), preferred category, HttpSession RBAC.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>5. Database Connectivity:</strong> MySQL 8.0 via JDBC <code>PreparedStatement</code> and connection utilities.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>6. AJAX Operations:</strong> Live service search, username availability check, pre-checkout availability.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>7. XML Retrieval &amp; Parsing:</strong> Asynchronous fetch of <code>/xml/skills.xml</code> parsed into an HTML table.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>8. Database-Driven Application:</strong> Relational schema with 9 tables, foreign keys, and referential integrity.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>9. E-Commerce Workflow:</strong> Browse &rarr; Hire &rarr; Requirements &rarr; Mock Payment &rarr; Order &rarr; Delivery &rarr; Review.
                </div>
                <div style="padding: 0.75rem 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <strong>10. Security &amp; Testing:</strong> SHA-256 password hashing, SQL injection prevention, RBAC filters, zero stack traces.
                </div>
            </div>
        </div>

        <!-- Course Outcome Mapping -->
        <div class="card" style="padding: 2.25rem;">
            <h2 style="font-size: 1.4rem; font-weight: 800; color: var(--text-primary); margin-bottom: 1.25rem;">Course Outcome (CO) Mapping</h2>
            <div style="display: flex; flex-direction: column; gap: 1rem; font-size: 0.92rem;">
                <div style="border-left: 3px solid var(--primary); padding-left: 1rem;">
                    <strong>CO1: Plan an internet-based business using appropriate business models and web technologies.</strong><br>
                    <span style="color: var(--text-secondary);">&rarr; SkillForge is structured as a student gig platform with client, freelancer, and administrator monetization and transaction models.</span>
                </div>
                <div style="border-left: 3px solid var(--primary); padding-left: 1rem;">
                    <strong>CO2: Select and apply markup languages.</strong><br>
                    <span style="color: var(--text-secondary);">&rarr; Implemented using semantic HTML5, dynamic JSP server pages, and XML for skills registry data exchange.</span>
                </div>
                <div style="border-left: 3px solid var(--primary); padding-left: 1rem;">
                    <strong>CO3: Design websites using security principles.</strong><br>
                    <span style="color: var(--text-secondary);">&rarr; Implemented SHA-256 hashing, parameterized PreparedStatements, server-side authorization filters, and session validation.</span>
                </div>
                <div style="border-left: 3px solid var(--primary); padding-left: 1rem;">
                    <strong>CO4: Navigation, usability and written content.</strong><br>
                    <span style="color: var(--text-secondary);">&rarr; Responsive design system, intuitive visual progress tracker, clear service cards, and sticky navigation.</span>
                </div>
                <div style="border-left: 3px solid var(--primary); padding-left: 1rem;">
                    <strong>CO5: Create a static website and add dynamic JavaScript functionality.</strong><br>
                    <span style="color: var(--text-secondary);">&rarr; Client-side validations, real-time debounce search, live DOM rendering, and XML parsing via JavaScript.</span>
                </div>
                <div style="border-left: 3px solid var(--primary); padding-left: 1rem;">
                    <strong>CO6: Web-based strategic business alignment.</strong><br>
                    <span style="color: var(--text-secondary);">&rarr; End-to-end e-commerce flow with client checkout, mock UPI/Card payment records, order status tracking, and verified reviews.</span>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp"/>
</body>
</html>
