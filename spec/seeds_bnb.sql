TRUNCATE TABLE users, spaces, requests RESTART IDENTITY;

INSERT INTO users (name, username, email, password) VALUES('Joel', 'joelio', 'joel@makers.com', 'password1');
INSERT INTO users (name, username, email, password) VALUES('Junaid', 'Junio', 'junaid@makers.com', 'password2');
INSERT INTO spaces (name, available, description, price, user_id) VALUES('Paradise Beach', 'true', 'Seaside getaway', '120', '1');
INSERT INTO spaces (name, available, description, price, user_id) VALUES('Cityscapes', 'true', 'Bright lights and candlelit bars', '100', '2');
INSERT INTO requests (date_of_request, approved, user_id, space_id) VALUES('2023-02-10', 'true', '2', '1');
INSERT INTO requests (date_of_request, approved, user_id, space_id) VALUES('2023-02-13', 'true', '1', '2');
