--PostgreSQL doesn't allow to run this inside a transaction block
CREATE INDEX CONCURRENTLY idx_users_username ON users (username);