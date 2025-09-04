
-- v01_06_create_table_users_roles.sql

-- \echo 'Starts v01_06_create_table_users_roles.sql';

create table users_roles (
    role_id integer not null,
    user_id integer not null,
    unique (user_id, role_id)
);

-- \echo 'Ends v01_06_create_table_users_roles.sql';