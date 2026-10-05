-- ====================================================================
-- SKILLFORGE DATABASE INITIALIZATION SCRIPT
-- "Forge your skills. Build your future."
-- Student-Focused Freelancing & Service Marketplace
-- ====================================================================

DROP DATABASE IF EXISTS skillforge_db;
CREATE DATABASE skillforge_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE skillforge_db;

-- --------------------------------------------------------------------
-- Table: users
-- Roles: CLIENT, FREELANCER, ADMIN
-- Status: ACTIVE, BLOCKED
-- --------------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL, -- CLIENT, FREELANCER, ADMIN
    profile_image VARCHAR(255) DEFAULT 'default-avatar.png',
    bio TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, BLOCKED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_role (role),
    INDEX idx_user_username (username),
    INDEX idx_user_email (email)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: categories
-- --------------------------------------------------------------------
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50) DEFAULT 'briefcase',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: skills
-- --------------------------------------------------------------------
CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_skill_category (category_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: user_skills (Freelancer skills)
-- --------------------------------------------------------------------
CREATE TABLE user_skills (
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (user_id, skill_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: services
-- Status: ACTIVE, INACTIVE, REMOVED
-- --------------------------------------------------------------------
CREATE TABLE services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    freelancer_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    delivery_days INT NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (freelancer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_service_category (category_id),
    INDEX idx_service_freelancer (freelancer_id),
    INDEX idx_service_status (status),
    INDEX idx_service_price (price),
    INDEX idx_service_rating (rating)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: orders
-- Status: PENDING, ACCEPTED, IN_PROGRESS, DELIVERED, COMPLETED, CANCELLED
-- --------------------------------------------------------------------
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    service_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDING',
    requirements TEXT,
    delivery_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    INDEX idx_order_client (client_id),
    INDEX idx_order_freelancer (freelancer_id),
    INDEX idx_order_status (status)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: payments
-- Methods: UPI, Credit/Debit Card, Offline Payment
-- Status: COMPLETED, PENDING, FAILED
-- --------------------------------------------------------------------
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    status VARCHAR(30) DEFAULT 'COMPLETED',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_payment_order (order_id),
    INDEX idx_payment_tx (transaction_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: reviews
-- Rating: 1 to 5
-- --------------------------------------------------------------------
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    client_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_review_freelancer (freelancer_id),
    INDEX idx_review_order (order_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- Table: wishlist
-- --------------------------------------------------------------------
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    service_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_client_service (client_id, service_id),
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- SEED DATA INSERTION
-- Password for users is "Password@123" (SHA-256 hash below)
-- Password for admin is "Admin@123" (SHA-256 hash below)
-- ====================================================================

-- 1. Users (Admin and Freelancer Aditya S only)
INSERT INTO users (id, name, username, email, password_hash, role, bio, profile_image, status) VALUES
-- Admin
(1, 'Admin Administrator', 'admin', 'admin@skillforge.com', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'ADMIN', 'SkillForge Chief Platform Administrator and Operations Manager.', 'avatar-admin.png', 'ACTIVE'),

-- Freelancer (Aditya S)
(2, 'Aditya S', 'aditya_dev', 'aditya@example.com', 'ff7bd97b1a7789ddd2775122fd6817f3173672da9f802ceec57f284325bf589f', 'FREELANCER', 'Final year Computer Science undergrad. Full-stack Java & Python developer, UI/UX designer, and video editor with 2+ years of freelance experience building SaaS apps.', 'avatar-aditya.png', 'ACTIVE');

-- 2. Categories
INSERT INTO categories (id, name, description, icon) VALUES
(1, 'Web & App Development', 'Full-stack web applications, frontends, APIs, mobile apps, and database integration.', 'code'),
(2, 'Graphic & UI/UX Design', 'Logos, branding kits, Figma wireframes, UI kits, and vector graphics.', 'palette'),
(3, 'Video & Media Editing', 'YouTube videos, reels, color grading, motion graphics, and audio editing.', 'video'),
(4, 'AI & Data Science', 'Machine learning models, Python automation scripts, web scraping, and data visualizations.', 'cpu'),
(5, 'Content & Tutoring', 'Technical writing, resume/CV design, academic tutoring, and pitch deck presentations.', 'book-open');

-- 3. Skills
INSERT INTO skills (id, name, category_id) VALUES
(1, 'Java', 1),
(2, 'JSP & Servlets', 1),
(3, 'React & JavaScript', 1),
(4, 'MySQL', 1),
(5, 'Figma & UI/UX', 2),
(6, 'Graphic Design & Logo', 2),
(7, 'Presentation & CV Design', 2),
(8, 'Video Editing', 3),
(9, 'Motion Graphics', 3),
(10, 'Python Scripting', 4),
(11, 'Machine Learning', 4),
(12, 'Technical Content Writing', 5),
(13, 'Programming Tutoring', 5);

-- 4. User Skills Mapping (Aditya S)
INSERT INTO user_skills (user_id, skill_id) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10), (2, 11), (2, 12), (2, 13);

-- 5. Services (1 active service for Aditya S; dynamic slots fill as new freelancers join)
INSERT INTO services (id, freelancer_id, category_id, title, description, price, delivery_days, rating, review_count, status) VALUES
(1, 2, 1, 'Build a Modern Full-Stack Website', 'I will build a responsive, production-ready full stack web application using Java, JSP, Servlets, and MySQL or modern JavaScript. Includes database design, clean architecture, and deployment support.', 3500.00, 5, 0.00, 0, 'ACTIVE');

