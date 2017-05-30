CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "venues" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "postcode" varchar, "area" varchar, "committee" varchar, "ward" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "latitude" float, "longitude" float, "easting" integer, "northing" integer, "postcode_no_space" varchar);
CREATE TABLE "providers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "url" varchar, "telephone" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "subjects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "code" varchar, "description" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "topics" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "subjects_topics" ("topic_id" integer, "subject_id" integer);
CREATE INDEX "index_subjects_topics_on_topic_id" ON "subjects_topics" ("topic_id");
CREATE INDEX "index_subjects_topics_on_subject_id" ON "subjects_topics" ("subject_id");
CREATE TABLE "admin_users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_admin_users_on_email" ON "admin_users" ("email");
CREATE UNIQUE INDEX "index_admin_users_on_reset_password_token" ON "admin_users" ("reset_password_token");
CREATE TABLE "active_admin_comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "namespace" varchar, "body" text, "resource_type" varchar, "resource_id" integer, "author_type" varchar, "author_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_active_admin_comments_on_resource_type_and_resource_id" ON "active_admin_comments" ("resource_type", "resource_id");
CREATE INDEX "index_active_admin_comments_on_author_type_and_author_id" ON "active_admin_comments" ("author_type", "author_id");
CREATE INDEX "index_active_admin_comments_on_namespace" ON "active_admin_comments" ("namespace");
CREATE TABLE "postcodes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "postcode" varchar DEFAULT NULL, "easting" integer DEFAULT NULL, "northing" integer DEFAULT NULL, "latitude" float DEFAULT NULL, "longitude" float DEFAULT NULL, "postcode_no_space" varchar DEFAULT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE VIRTUAL TABLE fts_courses USING fts3(title, description, soundex, tokenize=porter);
CREATE TABLE 'fts_courses_content'(docid INTEGER PRIMARY KEY, 'c0title', 'c1description', 'c2soundex');
CREATE TABLE 'fts_courses_segments'(blockid INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE 'fts_courses_segdir'(level INTEGER,idx INTEGER,start_block INTEGER,leaves_end_block INTEGER,end_block INTEGER,root BLOB,PRIMARY KEY(level, idx));
CREATE TABLE "courses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar DEFAULT NULL, "description" text DEFAULT NULL, "target_group" varchar DEFAULT NULL, "status" varchar DEFAULT NULL, "qualification" varchar DEFAULT NULL, "start_date" date DEFAULT NULL, "end_date" date DEFAULT NULL, "start_time" time DEFAULT NULL, "end_time" time DEFAULT NULL, "hours" float DEFAULT NULL, "target_number" integer DEFAULT NULL, "enrolment_count" integer DEFAULT NULL, "lcc_code" varchar DEFAULT NULL, "provider_code" varchar DEFAULT NULL, "academic_year" varchar DEFAULT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "venue_id" integer DEFAULT NULL, "provider_id" integer DEFAULT NULL, "subject_id" integer DEFAULT NULL, "latitude" float, "longitude" float);
CREATE INDEX "index_courses_on_venue_id" ON "courses" ("venue_id");
CREATE INDEX "index_courses_on_provider_id" ON "courses" ("provider_id");
CREATE INDEX "index_courses_on_subject_id" ON "courses" ("subject_id");
INSERT INTO "schema_migrations" (version) VALUES
('20170516152940'),
('20170516153814'),
('20170516153952'),
('20170516154603'),
('20170516154618'),
('20170516154943'),
('20170516160340'),
('20170516160807'),
('20170517133407'),
('20170517163049'),
('20170517163052'),
('20170522151203'),
('20170522162847'),
('20170522163415'),
('20170529162452'),
('20170530122550');


