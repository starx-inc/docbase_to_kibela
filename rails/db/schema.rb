# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_03_083253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachiment_files", id: :string, force: :cascade do |t|
    t.string "name", limit: 2048
    t.string "url", limit: 2048
    t.text "markdown"
    t.string "local_path", limit: 2048
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kibela_id"
    t.datetime "kibela_updated_at"
    t.string "kibela_path"
    t.string "drive_path"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kibela_id"
    t.datetime "kibela_updated_at"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kibela_id"
    t.index ["post_id"], name: "index_groups_on_post_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "post_attachiment_files", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "attachiment_file_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachiment_file_id"], name: "index_post_attachiment_files_on_attachiment_file_id"
    t.index ["post_id"], name: "index_post_attachiment_files_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", limit: 1024
    t.text "body"
    t.string "origin_url", limit: 1024
    t.string "scope", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "kibela_id"
    t.datetime "kibela_updated_at"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "related_posts", force: :cascade do |t|
    t.bigint "reference_post_id", null: false
    t.bigint "source_post_id", null: false
    t.boolean "converted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reference_post_id"], name: "index_related_posts_on_reference_post_id"
    t.index ["source_post_id"], name: "index_related_posts_on_source_post_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_tags_on_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "docbase_id", null: false
    t.string "docbase_name"
    t.string "docbase_email"
    t.string "kibela_id"
    t.string "kibela_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "groups", "posts"
  add_foreign_key "post_attachiment_files", "attachiment_files"
  add_foreign_key "post_attachiment_files", "posts"
  add_foreign_key "posts", "users"
  add_foreign_key "related_posts", "posts", column: "reference_post_id"
  add_foreign_key "related_posts", "posts", column: "source_post_id"
  add_foreign_key "tags", "posts"
end
