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

ActiveRecord::Schema.define(version: 201806242135000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "notifiable_apps", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "configuration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifiable_device_tokens", id: :serial, force: :cascade do |t|
    t.string "token"
    t.string "provider"
    t.string "locale"
    t.string "user_alias"
    t.integer "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "language"
    t.string "region"
    t.index ["app_id", "token"], name: "index_notifiable_device_tokens_on_app_id_and_token", unique: true
    t.index ["user_alias"], name: "index_notifiable_device_tokens_on_user_alias"
  end

  create_table "notifiable_notifications", id: :serial, force: :cascade do |t|
    t.integer "app_id"
    t.integer "sent_count", default: 0
    t.integer "gateway_accepted_count", default: 0
    t.integer "opened_count", default: 0
    t.text "message"
    t.text "parameters"
    t.string "sound"
    t.string "identifier"
    t.datetime "expiry"
    t.boolean "content_available"
    t.boolean "mutable_content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "badge_count"
    t.text "last_error_message"
    t.string "title"
    t.string "thread_id"
    t.string "category"
  end

  create_table "notifiable_statuses", id: :serial, force: :cascade do |t|
    t.integer "notification_id"
    t.integer "device_token_id"
    t.integer "status"
    t.datetime "created_at"
  end

end
