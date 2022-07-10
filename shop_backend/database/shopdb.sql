CREATE TABLE roles(
    id SERIAL PRIMARY KEY,
    role_type VARCHAR(10) NOT NULL
);

INSERT INTO
    roles (role_type)
VALUES
    ('admin'),
    ('seller'),
    ('buyer');

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    firstname VARCHAR(30) NOT NULL,
    sirname VARCHAR(30) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR (100) NULL,
    password VARCHAR(100) NOT NULL,
    joined_on VARCHAR(30) NOT NULL,
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
        joined_on,
        role_id
    )
VALUES
    (
        'Admin',
        'Admin',
        '0',
        '',
        'admin001',
        '01-07-2022, 00:00:00',
        1
    ),
    (
        'Juma',
        'Adinani',
        '255755384902',
        'Morogoro - Tanzania',
        'jumaadinani',
        '01-07-2022, 00:00:00',
        3
    ),
    (
        'Asha',
        'Mohammedi',
        '255688904029',
        'Dar Es Salaam - Tanzania',
        'ashamohammedi',
        '01-07-2022, 00:00:00',
        3
    ),
    (
        'Joshua',
        'Anthony',
        '255620300029',
        'Mwanza - Tanzania',
        'joshuaanthony',
        '01-07-2022, 00:00:00',
        3
    );

CREATE TABLE product_categories(
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO
    product_categories(category_name)
VALUES
    ('Furnitures'),
    ('Clothes'),
    ('Food'),
    ('Bevarage'),
    ('Electronics'),
    ('Decorations');

CREATE TABLE products(
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(30) NOT NULL,
    description VARCHAR (500) NOT NULL UNIQUE,
    price VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    product_photo VARCHAR(400) NOT NULL,
    posted_on VARCHAR(30) NOT NULL,
    category_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES product_categories (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE cart(
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    ordered_quantity INT NOT NULL,
    user_id INT NOT NULL,
    added_on VARCHAR(30) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE order_status(
    id SERIAL PRIMARY KEY,
    status VARCHAR(10) NOT NULL
);

INSERT INTO
    order_status (status)
VALUES
    ('Pending'),
    ('Completed');

CREATE TABLE orders(
    id SERIAL PRIMARY KEY,
    order_id VARCHAR(100) NOT NULL,
    product_id INT NOT NULL,
    ordered_quantity INT NOT NULL,
    order_date VARCHAR(30) NOT NULL,
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

CREATE TABLE payment_methods(
    id SERIAL PRIMARY KEY,
    phoneNumber VARCHAR(15) UNIQUE NOT NULL,
    amount INT NOT NULL,
    pin INT NOT NULL
);