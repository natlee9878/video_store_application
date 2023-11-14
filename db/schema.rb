# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_14_031046) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "actor_videos", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "video_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_actor_videos_on_actor_id"
    t.index ["video_id"], name: "index_actor_videos_on_video_id"
  end

  create_table "actors", force: :cascade do |t|
    t.string "first_name", limit: 50
    t.string "last_name", limit: 50
    t.date "birthdate"
    t.integer "gender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["gender_id"], name: "index_actors_on_gender_id"
  end

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "genres_videos", id: false, force: :cascade do |t|
    t.integer "video_id"
    t.integer "genre_id"
    t.index ["genre_id"], name: "index_genres_videos_on_genre_id"
    t.index ["video_id"], name: "index_genres_videos_on_video_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
  end

  create_table "rentals", primary_key: "order_number", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "order_date", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "return_date", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.boolean "returned", default: false
    t.string "order_titles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "format_type"
    t.integer "video_id"
    t.index ["user_id"], name: "index_rentals_on_user_id"
  end

  create_table "rentals_videos", force: :cascade do |t|
    t.integer "order_number", null: false
    t.integer "video_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "format_type"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "video_id", null: false
    t.integer "format_type"
    t.integer "number_owned"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "on_hand"
    t.string "active", default: "yes"
    t.decimal "cost"
    t.index ["video_id"], name: "index_stocks_on_video_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "address_line"
    t.string "suburb"
    t.integer "state", default: 0, null: false
    t.string "role", default: "regular"
    t.integer "postcode", limit: 4
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "content_rating"
    t.string "thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genre"
    t.integer "avg_rating"
    t.boolean "active"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "actor_videos", "actors"
  add_foreign_key "actor_videos", "videos"
  add_foreign_key "actors", "genders"
  add_foreign_key "rentals", "users"
  add_foreign_key "stocks", "videos"
end
