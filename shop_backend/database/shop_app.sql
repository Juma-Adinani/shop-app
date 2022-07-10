CREATE DATABASE shop_app;

USE shop_app;

CREATE TABLE roles(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    role_type VARCHAR(10) NOT NULL
);

INSERT INTO
    roles (role_type)
VALUES
    ('admin'),
    ('seller'),
    ('buyer');

CREATE TABLE users(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(30) NOT NULL,
    sirname VARCHAR(30) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR (100) NULL,
    password VARCHAR(100) NOT NULL,
    joined_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles (id)
);

INSERT INTO
    users (
        firstname,
        sirname,
        phone_number,
        address,
        password,
        role_id
    )
VALUES
    ('Admin', 'Admin', '0', '', sha1('admin'), 1),
    (
        'Juma',
        'Adinani',
        '255755384902',
        'Morogoro - Tanzania',
        sha1('jumaadinani'),
        3
    ),
    (
        'Asha',
        'Mohammedi',
        '255688904029',
        'Dar Es Salaam - Tanzania',
        sha1('ashamohammedi'),
        3
    ),
    (
        'Joshua',
        'Anthony',
        '255620300029',
        'Mwanza - Tanzania',
        sha1('joshuaanthony'),
        3
    );

CREATE TABLE product_categories(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO
    product_categories(category_name)
VALUES
    ('Samani'),('Mavazi'),('Vyakula'),('Vinywaji'),('vifaa vya umeme'),('mapambo');

CREATE TABLE products(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(30) NOT NULL,
    description VARCHAR (500) NOT NULL UNIQUE,
    price VARCHAR(10) NOT NULL,
    quantity INT (4) NOT NULL,
    product_photo VARCHAR(400) NOT NULL,
    posted_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    category_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES product_categories (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE cart(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    ordered_quantity INT NOT NULL,
    user_id INT NOT NULL,
    added_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);


CREATE TABLE order_status(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(10) NOT NULL
);

INSERT INTO
    order_status (status)
VALUES
    ('Pending'),
    ('Completed');

CREATE TABLE orders(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(100) NOT NULL,
    product_id INT NOT NULL,
    ordered_quantity INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR (100) NOT NULL,
    phone_number VARCHAR (12) NOT NULL,
    amount INT NOT NULL,
    to_be_paid INT NOT NULL,
    user_id INT NOT NULL,
    status_id INT NULL,
    FOREIGN KEY (product_id) REFERENCES products (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (status_id) REFERENCES order_status (id)
);

-- CREATE TABLE shop_account(
--     id INT NOT NULL AUTO_INCREMENT,
--     order_stamp VARCHAR(100) NOT NULL,
--     received_amount INT NOT NULL,
--     bonus_status VARCHAR(40) NOT NULL,
--     user_id INT NOT NULL,
--     done_on DATETIME DEFAULT CURRENT_TIMESTAMP,
--     PRIMARY KEY (id),
--     FOREIGN KEY (user_id) REFERENCES users (id)
-- );

CREATE TABLE payment_methods(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    phoneNumber VARCHAR(12) UNIQUE NOT NULL,
    amount INT(10) NOT NULL,
    pin INT(4) NOT NULL
);

