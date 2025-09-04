
-- v01_0XXX_create_foreign_key_XXX

-- \echo 'Starts v01_10_create_foreign_key_users_roles_many_to_many.sql';

--many_to_many
alter table if exists users_roles
    add constraint a_role_has_a_owner
    foreign key (role_id)
    references roles
;
alter table if exists users_roles
    add constraint a_user_has_a_role
    foreign key (user_id)
    references users
;

-- \echo 'Ends v01_10_create_foreign_key_users_roles_many_to_many.sql';
