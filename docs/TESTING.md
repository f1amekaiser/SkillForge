# SkillForge - Web Application Testing & Verification Suite

### "Forge your skills. Build your future."
**Web Technology Course Testing & Security Documentation**

---

## 1. Functional Testing

| Test Case ID | Test Scenario | Input Data / Action | Expected Result | Status |
|---|---|---|---|---|
| **TC-FN-01** | User Registration (Client) | Name: Sneha Patel, Username: sneha_test, Role: CLIENT | User created in `users` table, password hashed with SHA-256, auto-logged in to `/client-dashboard`. | **PASSED** |
| **TC-FN-02** | User Registration (Freelancer) | Role: FREELANCER with selected skill tags (Java, React) | Account created, entries inserted into `user_skills` mapping table, redirected to `/freelancer-dashboard`. | **PASSED** |
| **TC-FN-03** | User Authentication | Username: `admin`, Password: `Admin@123` | Validates hash, establishes `HttpSession`, redirects to `/admin-dashboard`. | **PASSED** |
| **TC-FN-04** | "Remember Me" Cookie | Check "Remember Me" checkbox on login | `rememberUser` cookie set with 30 days maxAge and HttpOnly flag. | **PASSED** |
| **TC-FN-05** | Logout & Session Invalidation | Click "Log Out" | `session.invalidate()` invoked, session cleared, redirected to `login.jsp?msg=logged_out`. | **PASSED** |
| **TC-FN-06** | Service Creation | Freelancer posts "Java REST API", ₹2,200, 4 days | Service inserted into `services` table with status 'ACTIVE', listed in `/my-services`. | **PASSED** |
| **TC-FN-07** | E-Commerce Checkout Flow | Client clicks "Hire Now", enters requirements | Pre-checkout AJAX availability verified, redirected to mock payment portal. | **PASSED** |
| **TC-FN-08** | Mock Payment Processing | Select UPI, click "Confirm Mock Payment" | Fake `TXN_UPI_...` generated, `orders` record created (PENDING), `payments` recorded (COMPLETED). | **PASSED** |
| **TC-FN-09** | Order Progress Lifecycle | Freelancer accepts -> starts -> delivers; Client approves | Order status transitions: PENDING &rarr; ACCEPTED &rarr; IN_PROGRESS &rarr; DELIVERED &rarr; COMPLETED. | **PASSED** |
| **TC-FN-10** | Review & Rating Recalculation | Client rates 5 stars with comment | Review saved in `reviews`, service `rating` & `review_count` updated in `services` table. | **PASSED** |

---

## 2. Validation Testing (Client-Side & Server-Side)

| Test Case ID | Test Scenario | Input Data / Action | Expected Result | Status |
|---|---|---|---|---|
| **TC-VL-01** | Empty Required Fields | Submit registration form with blank fields | Client-side blocks submission; server-side returns "All mandatory fields must be filled." | **PASSED** |
| **TC-VL-02** | Invalid Email Format | Input `user@domain` without TLD | Regex check fails, field highlighted with red border, error shown. | **PASSED** |
| **TC-VL-03** | Short Password (<6 chars) | Input password `123` | Form blocks submission with "Password must be at least 6 characters long." | **PASSED** |
| **TC-VL-04** | Password Mismatch | Password: `Password@123`, Confirm: `Mismatch@123` | Highlighted error "Passwords do not match." | **PASSED** |
| **TC-VL-05** | Negative / Zero Service Price | Price: `-500` or `0` | Blocked by validation; must be positive number &gt; ₹0. | **PASSED** |
| **TC-VL-06** | Invalid Delivery Days | Delivery days: `0` or `45` | Form requires valid duration between 1 and 30 days. | **PASSED** |

---

## 3. Security Testing

| Test Case ID | Test Scenario | Attack / Vulnerability Vector | Defense Implemented | Status |
|---|---|---|---|---|
| **TC-SEC-01** | SQL Injection in Login | Username: `' OR '1'='1' --` | `PreparedStatement` with parameterized placeholders `?` completely prevents SQL injection. | **PASSED** |
| **TC-SEC-02** | SQL Injection in Search | Search input: `web'; DROP TABLE services; --` | `PreparedStatement` safely escapes all dynamic filter parameters. | **PASSED** |
| **TC-SEC-03** | Unauthorized URL Access | Direct URL navigation to `/admin-dashboard` by non-admin | `AuthenticationFilter` intercepts and redirects to `/access-denied.jsp`. | **PASSED** |
| **TC-SEC-04** | Cross-Role Access Violation | Freelancer trying to access `/client-dashboard` | Role mismatch detected; blocked and redirected to `access-denied.jsp`. | **PASSED** |
| **TC-SEC-05** | Password Storage Plaintext | Inspect database table `users` | All passwords stored strictly as 64-character hex SHA-256 hashes. | **PASSED** |
| **TC-SEC-06** | Error Stack Trace Leakage | Access non-existent page `/unknown` or trigger DB error | Custom `error.jsp` displays friendly message; stack traces suppressed. | **PASSED** |
| **TC-SEC-07** | Sensitive Data in Cookies | Inspect `rememberUser` cookie | Contains only the non-sensitive username; passwords are never stored in cookies. | **PASSED** |

---

## 4. AJAX & Asynchronous Operations Testing

| Test Case ID | Feature | Endpoint | Verification | Status |
|---|---|---|---|---|
| **TC-AJX-01** | Live Username Check | `/api/check-username?username=aditya_dev` | Returns `{"available": false, "message": "✕ Username already exists"}` instantly as user types. | **PASSED** |
| **TC-AJX-02** | Live Service Search | `/api/search-services?q=Python` | Returns JSON array of matching services; DOM is re-rendered without page reload. | **PASSED** |
| **TC-AJX-03** | Dynamic Category Filter | `/api/search-services?categoryId=1` | Updates marketplace grid asynchronously on dropdown change. | **PASSED** |
| **TC-AJX-04** | Wishlist Toggle | `/api/wishlist/toggle` | Toggles item in database, updates heart icon to `❤️`, and triggers toast. | **PASSED** |
| **TC-AJX-05** | XML Skills Table Parsing | `/xml-skills.jsp` &rarr; `/xml/skills.xml` | `XMLHttpRequest` fetches XML, `DOMParser` extracts nodes, populates dynamic HTML table. | **PASSED** |

---

## 5. Usability & UI Testing

- **Responsive Breakpoints:** Tested across 1440px (Desktop), 1024px (Tablet Landscape), 768px (Tablet Portrait), and 375px (Mobile).
- **Navigation:** Sticky navbar with active page indicators and mobile slide-down drawer.
- **Visual Feedback:** Interactive toast notifications for all major user actions (order placed, review submitted, service created).
- **Empty States:** Clean illustration and helpful CTA buttons on empty wishlists, empty search results, and new accounts.
