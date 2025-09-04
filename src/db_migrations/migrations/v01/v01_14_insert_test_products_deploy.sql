
-- v01_14_insert_test_products.sql

-- \echo 'Starts v01_14_insert_test_products.sql';

INSERT INTO products(id, name, price, amount, description, created_at) VALUES(1, 'Ceramic Mug', 11.99, 50, 'A stylish ceramic mug for your favorite beverages.', '2024-01-10');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(2, 'Stainless Steel Water Bottle', 15.50, 30, 'Keep your drinks cold or hot with this durable water bottle.', '2024-01-11');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(3, 'Bluetooth Speaker', 29.99, 20, 'Portable speaker with excellent sound quality.', '2024-01-12');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(4, 'Yoga Mat', 24.99, 40, 'Eco-friendly yoga mat for your fitness routine.', '2024-01-13');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(5, 'Desk Organizer', 19.99, 15, 'Keep your workspace tidy with this desk organizer.', '2024-01-14');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(6, 'Wireless Earbuds', 49.99, 25, 'Experience true wireless freedom with these earbuds.', '2024-01-15');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(7, 'Backpack', 39.99, 100, 'Spacious and stylish backpack for everyday use.', '2024-01-16');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(8, 'LED Desk Lamp', 34.99, 35, 'Brighten your workspace with this adjustable desk lamp.', '2024-01-17');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(9, 'Notebooks Set', 12.50, 60, 'A set of colorful notebooks for school or office use.', '2024-01-18');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(10, 'Cooking Utensils Set', 19.99, 15, 'Essential kitchen tools for every home chef.', '2024-01-19');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(11, 'Wall Art Print', 25.00, 71, 'Beautiful art print to decorate your space.', '2024-01-20');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(12, 'Portable Charger', 29.99, 22, 'Never run out of battery with this portable charger.', '2024-01-21');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(13, 'Fitness Tracker', 49.99, 40, 'Monitor your health and fitness with this tracker.', '2024-01-22');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(14, 'Coffee Maker', 89.99, 60, 'Brew your perfect cup of coffee every morning.', '2024-01-23');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(15, 'Smartphone Stand', 14.99, 18, 'Adjustable stand for your smartphone or tablet.', '2024-01-24');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(16, 'Pet Bed', 34.99, 10, 'Cozy bed for your furry friend.', '2024-01-25');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(17, 'Potted Plant', 16.99, 12, 'Bring life to your home with this lovely potted plant.', '2024-01-26');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(18, 'Travel Pillow', 19.99, 25, 'Comfortable pillow for your travels.', '2024-01-27');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(19, 'Skincare Set', 39.99, 35, 'Complete set for glowing skin.', '2024-01-28');
INSERT INTO products(id, name, price, amount, description, created_at) VALUES(20, 'Board Game', 29.99, 15, 'Fun board game for family and friends.', '2024-01-29');
INSERT INTO products(id, name, price, amount, description, created_at, deleted_at) VALUES(21, 'Game 2', 70.50, 15, 'for fun and more.', '2024-03-21', '2024-03-22');

SELECT setval('products_id_seq', 30, true);



INSERT INTO product_images(id, id_product, name, type, created_at, image) VALUES(1, 1, 'image1.png', 'image/png', '2024-01-11 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a0bea78b63884670724a54cdfffffbffcfe159c224b66c3b4ffd3f4e6383898b25591c66393670fa0431b8f14a54304b483084b473afab17b588006a65f074f57359e794d004002a1b2662');
INSERT INTO product_images(id, id_product, name, type, created_at, image) VALUES(2, 1, 'image2.png', 'image/png', '2024-01-22 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a0b2a78b638846707248d4c39ff31b27cf6c8c39e0d2992690d07429a5399099ed1e031b1bc3ff50269b3b967edf81ca193c5dfd5cd639253401007fc024c8');
INSERT INTO product_images(id, id_product, name, type, created_at, image) VALUES(3, 1, 'image3.png', 'image/png', '2024-02-25 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d0161c6a9da7cd24041194f17c7108de0e43fff3b1fda33b336707a4de675e39560633330606038769499e9f251dd4d40750c9eae7e2eeb9c129a001ea61f25');
INSERT INTO product_images(id, id_product, name, type, created_at, image) VALUES(4, 1, 'image4.png', 'image/png', '2024-03-10 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a08ca78b63884670724a42c20ffe2329cc6a1abe6612a6091212070e3030446e6614d42fd74d06aa63f074f57359e794d0040003f91e1a');
INSERT INTO product_images(id, id_product, name, type, created_at, image) VALUES(5, 2, 'image5.png', 'image/png', '2024-04-10 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a0b2a78b638846707248d4c39ff31b27cf6c8c39e0d2992690d07429a5399099ed1e031b1bc3ff50269b3b967edf81ca193c5dfd5cd639253401007fc024c8');
INSERT INTO product_images(id, id_product, name, type, created_at, image) VALUES(6, 2, 'image6.png', 'image/png', '2024-05-12 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a0bea78b63884670724a54cdfffffbffcfe159c224b66c3b4ffd3f4e6383898b25591c66393670fa0431b8f14a54304b483084b473afab17b588006a65f074f57359e794d004002a1b2662');
INSERT INTO product_images(id, id_product, name, type, created_at, deleted_at, image) VALUES(7, 3, 'image7.png', 'image/png', '2024-01-10 09:57:00', '2024-03-22 09:57:00', '\x78daeb0cf073e7e592e2626060e0f5f4700902d20240ccc9c10624adb5d6180129c6e22077278675e7645e02392ce98ebe8e0c0c1bfbb9ff24b28254167844163330f01d026146510daf06a0a0bea78b63884670724a54cdfffffbffcfe159c224b66c3b4ffd3f4e6383898b25591c66393670fa0431b8f14a54304b483084b473afab17b588006a65f074f57359e794d004002a1b2662');
SELECT setval('product_images_id_seq', 30, true);

-- \echo 'Ends v01_14_insert_test_products.sql';