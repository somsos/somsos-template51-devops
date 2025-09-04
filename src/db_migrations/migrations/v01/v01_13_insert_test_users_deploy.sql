
-- v01_13_insert_test_users.sql

-- \echo 'Starts v01_13_insert_test_users.sql';

INSERT INTO users(id, username, password, created_at, email, updated_at) VALUES(1, 'john', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '1 day', 'john_doe@email.com', now() - interval '3 hours');
INSERT INTO users(id, username, password, created_at, email) VALUES(2, 'jane', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '2 days', 'jane_smith@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(3, 'lucas', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '3 days', 'lucas_wilson@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(4, 'emily', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '4 days', 'emily_jones@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(5, 'david', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '5 days', 'david_brown@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(6, 'susan', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '6 days', 'susan_clark@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(7, 'michael', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '7 days', 'michael_lee@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(8, 'lily', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '8 days', 'lily_martin@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(9, 'alex', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '9 days', 'alex_taylor@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(10, 'emily3', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now(), 'emily3@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(11, 'mike4', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '1 day 10 minutes', 'mike4@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(12, 'anna5', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '2 days 20 minutes', 'anna5@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(13, 'paul6', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '3 days 30 minutes', 'paul6@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(14, 'zoe7', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '4 days 40 minutes', 'zoe7@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(15, 'john8', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '5 days 50 minutes', 'john8@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(16, 'lucy9', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '6 days 60 minutes', 'lucy9@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(17, 'tom10', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '7 days 70 minutes', 'tom10@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(18, 'sara11', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '8 days 80 minutes', 'sara11@email.com');
INSERT INTO users(id, username, password, created_at, email) VALUES(19, 'mark12', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '9 days 90 minutes', 'mark12@email.com');

SELECT setval('users_id_seq', 20, true);


INSERT INTO users_picture(id, id_user, type, created_at, file) VALUES(1, 1, 'image1.png', '2024-01-11 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a0bea78b63884670724a54cdfffffbffcfe159c224b66c3b4ffd3f4e6383898b25591c66393670fa0431b8f14a54304b483084b473afab17b588006a65f074f57359e794d004002a1b2662');
SELECT setval('users_picture_id_seq', 100, true);


-- \echo 'Ends v01_13_insert_test_users.sql';