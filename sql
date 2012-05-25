BEGIN;
CREATE TABLE "codereview_issue" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "subject" varchar(500) NOT NULL,
    "description" text,
    "base" varchar(500),
    "local_base" boolean,
    "repo_guid" varchar(500),
    "owner_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "created" timestamp with time zone,
    "modified" timestamp with time zone,
    "reviewers" text NOT NULL,
    "cc" text NOT NULL,
    "closed" boolean,
    "private" boolean,
    "n_comments" integer
)
;
CREATE TABLE "codereview_patchset" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "issue_id" integer REFERENCES "codereview_issue" ("id") DEFERRABLE INITIALLY DEFERRED,
    "message" varchar(500),
    "data" text,
    "url" varchar(200),
    "created" timestamp with time zone,
    "modified" timestamp with time zone,
    "n_comments" integer
)
;
CREATE TABLE "codereview_message" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "issue_id" integer REFERENCES "codereview_issue" ("id") DEFERRABLE INITIALLY DEFERRED,
    "subject" varchar(500),
    "sender" varchar(75),
    "recipients" text NOT NULL,
    "date" timestamp with time zone,
    "text" text,
    "draft" boolean,
    "in_reply_to_id" integer
)
;
ALTER TABLE "codereview_message" ADD CONSTRAINT "in_reply_to_id_refs_id_647ac673" FOREIGN KEY ("in_reply_to_id") REFERENCES "codereview_message" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE "codereview_content" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "text" text,
    "data" text,
    "checksum" text,
    "is_uploaded" boolean,
    "is_bad" boolean,
    "file_too_large" boolean
)
;
CREATE TABLE "codereview_patch" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "patchset_id" integer REFERENCES "codereview_patchset" ("id") DEFERRABLE INITIALLY DEFERRED,
    "filename" varchar(500),
    "status" varchar(500),
    "text" text,
    "content_id" integer REFERENCES "codereview_content" ("id") DEFERRABLE INITIALLY DEFERRED,
    "patched_content_id" integer REFERENCES "codereview_content" ("id") DEFERRABLE INITIALLY DEFERRED,
    "is_binary" boolean,
    "delta" text NOT NULL,
    "delta_calculated" boolean
)
;
CREATE TABLE "codereview_comment" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "patch_id" integer REFERENCES "codereview_patch" ("id") DEFERRABLE INITIALLY DEFERRED,
    "message_id" varchar(500),
    "author_id" integer REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "date" timestamp with time zone,
    "lineno" integer,
    "text" text,
    "left" boolean,
    "draft" boolean
)
;
CREATE TABLE "codereview_bucket" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "text" text,
    "quoted" boolean
)
;
CREATE TABLE "codereview_repository" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "name" varchar(500) NOT NULL,
    "url" varchar(200) NOT NULL,
    "owner_id" integer REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "guid" varchar(500)
)
;
CREATE TABLE "codereview_branch" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "repo_id" integer NOT NULL REFERENCES "codereview_repository" ("id") DEFERRABLE INITIALLY DEFERRED,
    "repo_name" varchar(500),
    "category" varchar(500) NOT NULL,
    "name" varchar(500) NOT NULL,
    "url" varchar(200) NOT NULL,
    "owner_id" integer REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED
)
;
CREATE TABLE "codereview_account" (
    "id" serial NOT NULL PRIMARY KEY,
    "gae_key" varchar(64) UNIQUE,
    "gae_parent_ctype_id" integer REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "gae_parent_id" integer CHECK ("gae_parent_id" >= 0),
    "gae_ancestry" varchar(500),
    "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "email" varchar(75) NOT NULL,
    "nickname" varchar(500) NOT NULL,
    "default_context" integer,
    "default_column_width" integer,
    "created" timestamp with time zone,
    "modified" timestamp with time zone,
    "stars" text NOT NULL,
    "fresh" boolean,
    "uploadpy_hint" boolean,
    "notify_by_email" boolean,
    "notify_by_chat" boolean,
    "lower_email" varchar(500),
    "lower_nickname" varchar(500),
    "xsrf_secret" text
)
;
COMMIT;
