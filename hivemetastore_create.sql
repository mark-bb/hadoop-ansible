CREATE DATABASE hivemetastore;
CREATE ROLE hive login;
GRANT ALL ON DATABASE hivemetastore TO hive;
\c hivemetastore
GRANT ALL ON schema public TO hive;
