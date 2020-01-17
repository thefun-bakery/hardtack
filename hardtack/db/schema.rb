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

ActiveRecord::Schema.define(version: 2020_01_17_014601) do

  create_table "emotion_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "emotion_id"
    t.bigint "file_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emotion_id"], name: "index_emotion_files_on_emotion_id"
    t.index ["file_id"], name: "index_emotion_files_on_file_id"
  end

  create_table "emotion_hug_counts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "emotion_id"
    t.integer "hug_count", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emotion_id"], name: "index_emotion_hug_counts_on_emotion_id"
  end

  create_table "emotion_hug_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "emotion_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emotion_id", "user_id"], name: "index_emotion_hug_histories_on_emotion_id_and_user_id", unique: true
    t.index ["emotion_id"], name: "index_emotion_hug_histories_on_emotion_id"
    t.index ["user_id"], name: "index_emotion_hug_histories_on_user_id"
  end

  create_table "emotions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "home_id"
    t.string "emotion_key", null: false
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emotion_key"], name: "index_emotions_on_emotion_key"
    t.index ["home_id"], name: "index_emotions_on_home_id"
    t.index ["user_id"], name: "index_emotions_on_user_id"
  end

  create_table "feeds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "emotion_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emotion_id"], name: "index_feeds_on_emotion_id"
    t.index ["follower_id", "emotion_id"], name: "index_feeds_on_follower_id_and_emotion_id", unique: true
    t.index ["follower_id"], name: "index_feeds_on_follower_id"
  end

  create_table "files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.boolean "upload_complete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_files_on_name", unique: true
    t.index ["user_id"], name: "index_files_on_user_id"
  end

  create_table "followers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "followee_id", null: false
    t.bigint "follower_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followee_id", "follower_id"], name: "index_followers_on_followee_id_and_follower_id", unique: true
    t.index ["followee_id"], name: "index_followers_on_followee_id"
    t.index ["follower_id"], name: "index_followers_on_follower_id"
  end

  create_table "home_visit_counts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "home_id"
    t.integer "visit_count", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["home_id"], name: "index_home_visit_counts_on_home_id"
  end

  create_table "home_visit_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "home_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["home_id"], name: "index_home_visit_histories_on_home_id"
    t.index ["user_id"], name: "index_home_visit_histories_on_user_id"
  end

  create_table "homes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", default: "my home", null: false
    t.string "desc", default: "welcome", null: false
    t.string "bgcolor", default: "000000", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_homes_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "service", limit: 10, null: false
    t.string "identifier", null: false
    t.string "profile_image_filename"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service", "identifier"], name: "index_users_on_service_and_identifier", unique: true
  end

end
