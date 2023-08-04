DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
   id SERIAL,
   name VARCHAR(30),
   text VARCHAR(150),
   PRIMARY KEY (id)
);

INSERT INTO memos (name, text) VALUES ('name', 'The first entry.');
INSERT INTO memos (name, text) VALUES ('name', 'The second entry.');