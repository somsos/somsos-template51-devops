
-- v01_12_insert_admin_users.sql

-- \echo 'Starts v01_12_insert_admin_users.sql';

INSERT INTO roles(id, authority) VALUES(-53, 'ROLE_registered');
INSERT INTO roles(id, authority) VALUES(-55, 'ROLE_admin_users');
INSERT INTO roles(id, authority) VALUES(-56, 'ROLE_admin_products');
INSERT INTO roles(id, authority) VALUES(-57, 'ROLE_admin_sells');


INSERT INTO users(id, username, password, created_at, email) VALUES(-100, 'mario1', '$2a$10$zyEAgLnFSxOzlww/V7DlNeWShEAwLp.fOo3Ds25nCrS5XyElb55Xm', now() - interval '100 day', 'mario1@email.com');
INSERT INTO users_roles(user_id, role_id) VALUES(-100, -55);
INSERT INTO users_roles(user_id, role_id) VALUES(-100, -56);


INSERT INTO users(id, username, password, created_at, email) VALUES(-99, 'mario2', '$2a$10$gSr8onLyPPNGe029IdJMPOD9lkv9q6kCfIcieOX4gSJ6rYIpW1rJi', now() - interval '99 day', 'mario2@email.com');
INSERT INTO users_roles(user_id, role_id) VALUES(-99, -56);


INSERT INTO users(id, username, password, created_at, email) VALUES(-98, 'mario3', '$2a$10$GF3mC0z3T6MkjAUoOxk04uwyvht0L457q71/lUM3f0F1tgxm.UNIS', now() - interval '98 day', 'mario3@email.com');
INSERT INTO users_roles(user_id, role_id) VALUES(-98, -57);


-- \echo 'Ends v01_12_insert_admin_users.sql';