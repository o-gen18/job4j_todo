CREATE TABLE task (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created TIMESTAMP,
    done BOOLEAN,
    user_id INT NOT NULL REFERENCES j_user(id)
);

CREATE TABLE j_role (
    id serial PRIMARY KEY,
    name VARCHAR(2000) NOT NULL
);

CREATE TABLE j_user (
    id serial PRIMARY KEY,
    name VARCHAR(2000) NOT NULL,
    email VARCHAR(2000) UNIQUE,
    role_id INT NOT NULL REFERENCES j_role(id),
    password TEXT
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);