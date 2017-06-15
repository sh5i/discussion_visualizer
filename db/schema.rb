# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170606045412) do

  create_table "auto_tag_authors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "author_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "tag_content"
    t.integer  "project_id"
    t.index ["project_id"], name: "index_auto_tag_authors_on_project_id", using: :btree
  end

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_bookmarks_on_comment_id", using: :btree
    t.index ["user_id"], name: "index_bookmarks_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "issue_id"
    t.string   "author"
    t.text     "content",     limit: 65535
    t.string   "type_text"
    t.string   "jira_id"
    t.integer  "internal_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["issue_id"], name: "index_comments_on_issue_id", using: :btree
  end

  create_table "edges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "to_comment_id", null: false
    t.string   "type_text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "reason"
    t.index ["comment_id"], name: "index_edges_on_comment_id", using: :btree
    t.index ["to_comment_id"], name: "index_edges_on_to_comment_id", using: :btree
    t.index ["user_id"], name: "index_edges_on_user_id", using: :btree
  end

  create_table "issue_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "issue_id"
    t.string   "target_issue_title"
    t.string   "target_issue_name"
    t.string   "type_text"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["issue_id"], name: "index_issue_relations_on_issue_id", using: :btree
  end

  create_table "issues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "url"
    t.string   "type_text"
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "status_type"
    t.index ["project_id"], name: "index_issues_on_project_id", using: :btree
    t.index ["user_id"], name: "index_issues_on_user_id", using: :btree
  end

  create_table "logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.datetime "actioned_at"
    t.index ["user_id"], name: "index_logs_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.string   "content"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "auto_tag_author_id"
    t.index ["auto_tag_author_id"], name: "index_tags_on_auto_tag_author_id", using: :btree
    t.index ["comment_id"], name: "index_tags_on_comment_id", using: :btree
    t.index ["user_id"], name: "index_tags_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "username",               default: "", null: false
    t.string   "role"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "item_type",  limit: 191,        null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "auto_tag_authors", "projects", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "issues", on_update: :cascade, on_delete: :cascade
  add_foreign_key "edges", "comments", on_update: :cascade, on_delete: :cascade
  add_foreign_key "issue_relations", "issues", on_update: :cascade, on_delete: :cascade
  add_foreign_key "issues", "projects", on_update: :cascade, on_delete: :cascade
  add_foreign_key "issues", "users", on_update: :nullify, on_delete: :nullify
  add_foreign_key "logs", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tags", "auto_tag_authors", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tags", "comments", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tags", "users", on_update: :cascade, on_delete: :cascade
end
