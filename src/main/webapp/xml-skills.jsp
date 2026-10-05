<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>XML AJAX Demonstration - SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
    <jsp:include page="navbar.jsp"/>

    <main class="container" style="padding: 3rem 1.5rem;">
        <div style="max-width: 900px; margin: 0 auto;">
            <!-- Header -->
            <div style="margin-bottom: 2rem;">
                <span class="badge badge-accepted" style="margin-bottom: 0.5rem;">Academic Requirement #7</span>
                <h1 style="font-size: 2.25rem; font-weight: 800; color: var(--text-primary); margin-bottom: 0.5rem;">
                    XML Document Retrieval &amp; Client-Side HTML Table Parsing
                </h1>
                <p style="color: var(--text-secondary); font-size: 1.05rem;">
                    This page explicitly demonstrates an asynchronous AJAX request retrieving an XML file (<a href="<%= ctx %>/xml/skills.xml" target="_blank" style="font-family: var(--font-mono); font-weight: 600;">/xml/skills.xml</a>), parsing the XML DOM tree in vanilla JavaScript, and dynamically generating an interactive HTML table.
                </p>
            </div>

            <!-- Architectural Workflow Banner -->
            <div class="card" style="padding: 1.5rem; margin-bottom: 2rem; background: linear-gradient(135deg, var(--bg-surface), #f1f5f9); border-left: 4px solid var(--primary);">
                <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.75rem;">
                    Demonstrated Technical Pipeline:
                </h4>
                <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 0.75rem; font-size: 0.88rem; font-weight: 600;">
                    <span class="badge badge-pending">1. XML Document (/xml/skills.xml)</span>
                    <span>&rarr;</span>
                    <span class="badge badge-accepted">2. AJAX XMLHttpRequest / Fetch</span>
                    <span>&rarr;</span>
                    <span class="badge badge-in_progress">3. XML Response (text/xml)</span>
                    <span>&rarr;</span>
                    <span class="badge badge-delivered">4. JavaScript DOMParser</span>
                    <span>&rarr;</span>
                    <span class="badge badge-completed">5. Dynamic HTML Table</span>
                </div>
            </div>

            <!-- Interactive Trigger -->
            <div class="card" style="padding: 1.75rem; margin-bottom: 2rem;">
                <div style="display: flex; flex-wrap: wrap; justify-content: space-between; align-items: center; gap: 1rem;">
                    <div>
                        <h3 style="font-size: 1.15rem; font-weight: 700;">Skills Registry XML Data</h3>
                        <p id="xmlStatusMsg" style="font-size: 0.88rem; color: var(--text-muted); margin-top: 0.25rem;">
                            Click below to initiate the asynchronous XML retrieval or inspect the live table.
                        </p>
                    </div>
                    <div style="display: flex; gap: 0.75rem;">
                        <button type="button" class="btn btn-primary" onclick="loadSkillsXML()" style="display: inline-flex; align-items: center; gap: 0.4rem;">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="23 4 23 10 17 10"></polyline><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg>
                            Fetch &amp; Parse XML Now
                        </button>
                        <a href="<%= ctx %>/xml/skills.xml" target="_blank" class="btn btn-secondary">
                            View Raw XML File &rarr;
                        </a>
                    </div>
                </div>

                <!-- Parsed HTML Table -->
                <div class="table-responsive" style="margin-top: 1.5rem;">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">ID</th>
                                <th>Skill Name</th>
                                <th>Category</th>
                                <th>Student Experience</th>
                                <th>Market Demand</th>
                            </tr>
                        </thead>
                        <tbody id="xmlSkillsTableBody">
                            <tr>
                                <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 2rem;">
                                    Loading skills from XML document...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Code Explanation Box -->
            <div class="card" style="padding: 1.75rem; background-color: var(--bg-surface);">
                <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 0.75rem;">Client-Side JavaScript XML Parser Snippet</h3>
                <pre style="background: #0f172a; color: #f8fafc; padding: 1.25rem; border-radius: var(--radius-md); font-family: var(--font-mono); font-size: 0.82rem; overflow-x: auto; line-height: 1.5;"><code>const xhr = new XMLHttpRequest();
xhr.open('GET', '<%= ctx %>/xml/skills.xml', true);
xhr.onreadystatechange = function() {
    if (xhr.readyState === 4 && xhr.status === 200) {
        const xmlDoc = xhr.responseXML;
        const skills = xmlDoc.getElementsByTagName('skill');
        for (let i = 0; i &lt; skills.length; i++) {
            const name = skills[i].getElementsByTagName('name')[0].textContent;
            const category = skills[i].getElementsByTagName('category')[0].textContent;
            // Append rows into HTML table dynamically...
        }
    }
};
xhr.send();</code></pre>
            </div>
        </div>
    </main>

    <script>
        // Automatically load XML on document ready
        document.addEventListener('DOMContentLoaded', () => {
            loadSkillsXML();
        });
    </script>

    <jsp:include page="footer.jsp"/>
</body>
</html>
