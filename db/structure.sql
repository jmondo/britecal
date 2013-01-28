CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "name" varchar(255), "uid" varchar(255), "token" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "cal_token" varchar(255));
CREATE INDEX "index_users_on_cal_token" ON "users" ("cal_token");
CREATE INDEX "index_users_on_uid" ON "users" ("uid");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130128025553');

INSERT INTO schema_migrations (version) VALUES ('20130128030834');