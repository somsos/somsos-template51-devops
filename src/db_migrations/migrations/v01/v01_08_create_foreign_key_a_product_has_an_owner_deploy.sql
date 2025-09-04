
-- v01_0XXX_create_foreign_key_XXX

-- \echo 'Starts v01_08_create_foreign_key_a_product_has_an_owner.sql';

alter table if exists products
    add constraint a_product_has_an_owner
    foreign key (id_owner)
    references users
;

-- \echo 'Ends v01_08_create_foreign_key_a_product_has_an_owner.sql';
