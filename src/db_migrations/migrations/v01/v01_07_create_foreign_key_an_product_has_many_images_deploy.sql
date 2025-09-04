
-- v01_07_create_foreign_key_an_product_has_many_images.sql

-- \echo 'Starts v01_07_create_foreign_key_an_product_has_many_images.sql';

alter table if exists product_images
    add constraint an_product_has_many_images
    foreign key (id_product)
    references products
;

-- \echo 'Ends v01_07_create_foreign_key_an_product_has_many_images.sql';
