
-- v01_09_create_foreign_key_an_user_picture_has_an_owner.sql

-- \echo 'Starts v01_09_create_foreign_key_an_user_picture_has_an_owner.sql';

alter table if exists users
    add constraint an_user_picture_has_an_owner
    foreign key (picture_id)
    references users_picture
;

-- \echo 'Ends v01_09_create_foreign_key_an_user_picture_has_an_owner.sql';