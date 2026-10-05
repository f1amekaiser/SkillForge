# SKILLFORGE
### "Forge your skills. Build your future."

A student-focused freelancing and service marketplace where university students offer digital services (web development, UI/UX, AI pipelines, video editing, tutoring) and clients can discover, hire, pay, and review them.

Developed as a comprehensive Web Technology academic project demonstrating Java Servlets, JSP, JDBC, MySQL, Cookies, Sessions, AJAX, XML DOM parsing, and Role-Based Access Control (RBAC).

---

## 1. Project Overview & Problem Statement
University students develop industry-relevant skills in software engineering, UI/UX, machine learning, and media editing during their coursework. However, mainstream freelancing platforms (Upwork, Fiverr) present high barriers to entry, high fees, and an oversaturated agency market.

**SkillForge** provides a dedicated campus freelance marketplace that connects students with clubs, campus organizations, small businesses, and peer clients seeking reliable, affordable digital work.

---

## 2. Key Features

### For Clients:
- **Service Discovery & Search:** Live AJAX search with multi-faceted filtering (category, price range, rating, delivery days) and dynamic sorting.
- **Service Details & Reviews:** Detailed gig specifications, freelancer credentials, student reviews, and star ratings.
- **Wishlist:** AJAX-powered wishlist with live heart toggle and dedicated wishlist management.
- **E-Commerce Checkout & Mock Payment:** Multi-step project requirements input and mock payment simulator (UPI, Card, Offline) generating authentic simulated transaction receipts.
- **Milestone Tracking & Reviews:** Visual progress tracker (`PENDING` &rarr; `ACCEPTED` &rarr; `IN_PROGRESS` &rarr; `DELIVERED` &rarr; `COMPLETED`) and verified feedback submission.

### For Student Freelancers:
- **Freelancer Studio Dashboard:** KPI metrics (Total Orders, Active Projects, Net Earnings in ₹, Client Rating).
- **Gig Inventory Management:** Full CRUD operations on services with custom pricing and delivery timelines.
- **Incoming Orders:** Lifecycle controls to accept, decline, commence, and submit deliverables with attachments/links.
- **Earnings & Ledger:** Financial ledger with simulated payout disbursements.
- **Profile & Skill Customization:** Manage bio, degree details, and featured skill tags.

### For Administrators:
- **Operations Dashboard:** Platform metrics (Total Users, Freelancers, Clients, Services, Orders, Platform Revenue).
- **User Moderation:** Role-based filters and instant account block/unblock toggles.
- **Service Catalog Oversight:** Content moderation and takedown of inappropriate gigs.
- **Order Oversight & Dispute Resolution:** Ability to inspect and override order states.
- **Category Management:** Create, edit, and delete service categories and icons.
- **Transaction Ledger:** Auditable log of all simulated mock payment transactions.

---

## 3. Technology Stack

| Layer | Technology | Description |
|---|---|---|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript | Responsive modern SaaS design system, CSS variables, cards, modals, toast alerts. No Tailwind CSS. |
| **Backend** | Java Servlets (Jakarta EE 6.0) | Controller layer with `doGet()` and `doPost()` routing, input validation, and session handling. |
| **View Engine** | JSP (Jakarta Server Pages 3.1) | Dynamic server-side rendering strictly adhering to MVC principles (no embedded SQL). |
| **Database** | MySQL 8.0 | Relational database with 9 normalized tables, foreign keys, and indexes. |
| **Connectivity** | JDBC (MySQL Connector/J) | Parameterized `PreparedStatement` queries and connection lifecycle management. |
| **Asynchronous** | AJAX (Fetch API / XMLHttpRequest) | Live search, username check, wishlist toggle, pre-checkout availability, and XML table parsing. |
| **Data Interchange** | XML (`skills.xml`) &amp; JSON | Demonstration of asynchronous XML document retrieval and client-side DOM parsing. |
| **Server** | Apache Tomcat 11.0 | Jakarta EE compliant servlet container. |

---

## 4. MVC Architecture & System Design

SkillForge follows a strict **Model-View-Controller (MVC)** with **Data Access Object (DAO)** pattern:

```
+-------------------------------------------------------------+
|                        Client Browser                       |
|           (HTML5 + Vanilla CSS3 + JavaScript / AJAX)        |
+-------------------------------------------------------------+
                               |  ^
              HTTP Request     |  |  JSP Rendered HTML / JSON
                               v  |
+-------------------------------------------------------------+
|                      Controller Layer                       |
|   (AuthenticationFilter + Java Servlets in com.skillforge)  |
+-------------------------------------------------------------+
                               |  ^
                Data Model     |  |  DTO / Models
                               v  |
+-------------------------------------------------------------+
|                          DAO Layer                          |
|             (UserDAO, ServiceDAO, OrderDAO, etc.)           |
+-------------------------------------------------------------+
                               |  ^
             JDBC PreparedStmts|  |  ResultSet Mapping
                               v  |
+-------------------------------------------------------------+
|                      Database Layer                         |
|                     (MySQL 8.0 Server)                      |
+-------------------------------------------------------------+
```

---

## 5. Database Schema & Tables

The database `skillforge_db` contains 9 tables:
1. `users` (id, name, username, email, password_hash, role, profile_image, bio, status, created_at)
2. `categories` (id, name, description, icon, created_at)
3. `skills` (id, name, category_id, created_at)
4. `user_skills` (user_id, skill_id)
5. `services` (id, freelancer_id, category_id, title, description, price, delivery_days, rating, review_count, status, created_at)
6. `orders` (id, client_id, freelancer_id, service_id, amount, status, requirements, delivery_message, created_at, completed_at)
7. `payments` (id, order_id, amount, payment_method, transaction_id, status, payment_date)
8. `reviews` (id, order_id, client_id, freelancer_id, rating, comment, created_at)
9. `wishlist` (id, client_id, service_id, created_at)

---

## 6. Installation & Execution Guide

### Prerequisites:
- Java JDK 21+
- Apache Maven 3.9+
- MySQL Server 8.0
- Apache Tomcat 11.0

### Step 1: Database Setup
Import the complete SQL script:
```bash
mysql -u root -proot < database/skillforge.sql
```

### Step 2: Build Application with Maven
Inside the `SkillForge` directory:
```bash
mvn clean package
```
This generates `target/SkillForge.war`.

Before starting Tomcat, set the database environment variables. In PowerShell:

```powershell
$env:DB_URL = "jdbc:mysql://localhost:3306/skillforge_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8"
$env:DB_USER = "root"
$env:DB_PASSWORD = "root"
```

### Step 3: Deploy to Tomcat 11
Copy the generated WAR to Tomcat's `webapps` directory:
```powershell
Copy-Item target\SkillForge.war "C:\Apache Software Foundation\Tomcat 11.0\webapps\SkillForge.war"
```

### Step 4: Start Tomcat
```powershell
& "C:\Apache Software Foundation\Tomcat 11.0\bin\startup.bat"
```
Or start the Windows service: `Start-Service Tomcat11`

### Step 5: Open Application
Navigate to: **`http://localhost:8080/SkillForge/`**

### Deploy on Render

The repository includes a `Dockerfile` and `render.yaml` for deploying the application
as a Tomcat web service on Render.

1. Push this repository to GitHub.
2. Create a free MySQL-compatible database with a provider that allows external
   connections, then import `database/skillforge.sql`.
3. In Render, select **New &rarr; Blueprint** and connect the GitHub repository.
4. Set the following environment variables for the `skillforge` service:

   ```text
   DB_URL=jdbc:mysql://<host>:<port>/<database>?useSSL=true&serverTimezone=UTC&characterEncoding=UTF-8
   DB_USER=<database-user>
   DB_PASSWORD=<database-password>
   ```

5. Deploy the service. Render builds the WAR with Maven and runs it on Tomcat 11.

The database must be hosted separately because Render's free web service does not
provide a free MySQL database. Never commit database credentials to the repository.
The container uses Render's automatically provided `PORT` value, binds Tomcat to
`0.0.0.0`, disables Tomcat's shutdown listener, and defaults to port `8080` when
run locally. Render's default port is advertised as `10000`.

---

## 7. Default Seed Credentials

| Role | Username | Password | Purpose |
|---|---|---|---|
| **Admin** | `admin` | `Admin@123` | Platform oversight, user management, category CRUD |
| **Freelancer (Aditya S)** | `aditya_dev` | `Password@123` | Student Freelancer (Aditya S) with full-stack Java, Python, UI/UX, video editing gigs |


---

## 8. Course Outcome (CO) Mapping

- **CO1: Business Model Alignment:** SkillForge implements a student digital freelancing marketplace connecting students with real campus clients.
- **CO2: Markup Languages:** Demonstrates HTML5 semantic layouts, JSP dynamic templates, and XML document processing.
- **CO3: Web Security:** Full SHA-256 password hashing, parameterized PreparedStatements, server-side authorization filters, session authentication, and error suppression.
- **CO4: Usability & Navigation:** Intuitive responsive design system, sticky navigation, visual order progress tracker, and empty-state guidance.
- **CO5: Dynamic Scripting & AJAX:** Real-time search, live username availability check, password strength meter, and XML DOM parsing.
- **CO6: E-Commerce Integration:** End-to-end purchasing workflow from service discovery to simulated UPI/Card checkout, order lifecycle management, and verified client reviews.
