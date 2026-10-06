-- SkillForge PostgreSQL seed data for Neon.
-- Run database/schema-neon.sql first.
-- Safe to run repeatedly.

INSERT INTO skillforge_users
    (id, name, username, email, password_hash, role, bio, profile_image, status)
VALUES
    (1, 'Admin Administrator', 'admin', 'admin@skillforge.com',
     'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7',
     'ADMIN', 'SkillForge Chief Platform Administrator and Operations Manager.',
     'avatar-admin.png', 'ACTIVE'),
    (2, 'Aditya S', 'aditya_dev', 'aditya@example.com',
     'ff7bd97b1a7789ddd2775122fd6817f3173672da9f802ceec57f284325bf589f',
     'FREELANCER',
     'Final year Computer Science undergrad. Full-stack Java & Python developer, UI/UX designer, and video editor with 2+ years of freelance experience building SaaS apps.',
     'avatar-aditya.png', 'ACTIVE')
ON CONFLICT DO NOTHING;

INSERT INTO skillforge_categories (id, name, description, icon)
VALUES
    (1, 'Web & App Development', 'Full-stack web applications, frontends, APIs, mobile apps, and database integration.', 'code'),
    (2, 'Graphic & UI/UX Design', 'Logos, branding kits, Figma wireframes, UI kits, and vector graphics.', 'palette'),
    (3, 'Video & Media Editing', 'YouTube videos, reels, color grading, motion graphics, and audio editing.', 'video'),
    (4, 'AI & Data Science', 'Machine learning models, Python automation scripts, web scraping, and data visualizations.', 'cpu'),
    (5, 'Content & Tutoring', 'Technical writing, resume/CV design, academic tutoring, and pitch deck presentations.', 'book-open')
ON CONFLICT DO NOTHING;

INSERT INTO skillforge_skills (id, name, category_id)
VALUES
    (1, 'Java', 1),
    (2, 'JSP & Servlets', 1),
    (3, 'React & JavaScript', 1),
    (4, 'PostgreSQL', 1),
    (5, 'Figma & UI/UX', 2),
    (6, 'Graphic Design & Logo', 2),
    (7, 'Presentation & CV Design', 2),
    (8, 'Video Editing', 3),
    (9, 'Motion Graphics', 3),
    (10, 'Python Scripting', 4),
    (11, 'Machine Learning', 4),
    (12, 'Technical Content Writing', 5),
    (13, 'Programming Tutoring', 5)
ON CONFLICT DO NOTHING;

INSERT INTO skillforge_user_skills (user_id, skill_id)
VALUES
    (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7),
    (2, 8), (2, 9), (2, 10), (2, 11), (2, 12), (2, 13)
ON CONFLICT DO NOTHING;

INSERT INTO skillforge_services
    (id, freelancer_id, category_id, title, description, price, delivery_days, rating, review_count, status)
VALUES
    (1, 2, 1, 'Build a Modern Full-Stack Website',
     'I will build a responsive, production-ready full stack web application using Java, JSP, Servlets, and PostgreSQL or modern JavaScript. Includes database design, clean architecture, and deployment support.',
     3500.00, 5, 0.00, 0, 'ACTIVE')
ON CONFLICT DO NOTHING;

-- Keep generated IDs above the seeded IDs for future inserts.
SELECT setval(
    pg_get_serial_sequence('skillforge_users', 'id'),
    GREATEST(COALESCE((SELECT MAX(id) FROM skillforge_users), 1), 1),
    true
);
SELECT setval(
    pg_get_serial_sequence('skillforge_categories', 'id'),
    GREATEST(COALESCE((SELECT MAX(id) FROM skillforge_categories), 1), 1),
    true
);
SELECT setval(
    pg_get_serial_sequence('skillforge_skills', 'id'),
    GREATEST(COALESCE((SELECT MAX(id) FROM skillforge_skills), 1), 1),
    true
);
SELECT setval(
    pg_get_serial_sequence('skillforge_services', 'id'),
    GREATEST(COALESCE((SELECT MAX(id) FROM skillforge_services), 1), 1),
    true
);
