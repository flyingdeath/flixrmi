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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111010151729) do

  create_table "aconnectors", :force => true do |t|
    t.integer  "ltitles_id"
    t.integer  "lactors_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dconnectors", :force => true do |t|
    t.integer  "ltitles_id"
    t.integer  "ldirectors_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fconnectors", :force => true do |t|
    t.integer  "ltitles_id"
    t.integer  "lformats_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "availability_int"
    t.datetime "availability"
  end

  create_table "gconnectors", :force => true do |t|
    t.integer  "ltitles_id"
    t.integer  "lgenres_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genrestrees", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lactors", :force => true do |t|
    t.string   "ext_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ldirectors", :force => true do |t|
    t.string   "ext_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lformats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lgenres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ltitles", :force => true do |t|
    t.string   "title"
    t.string   "ext_id"
    t.string   "netflixLink"
    t.integer  "release_year"
    t.string   "updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "titleType"
  end

  create_table "lupcs", :force => true do |t|
    t.string   "number"
    t.integer  "ltitle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_caches", :force => true do |t|
    t.string   "alternate_link"
    t.string   "BoxArtMedium"
    t.string   "BoxArtLarge"
    t.string   "BoxArtSmall"
    t.string   "runtime"
    t.string   "ext_id"
    t.string   "predicted_rating"
    t.string   "average_rating"
    t.string   "user_rating"
    t.string   "user_id"
    t.string   "title_formats"
    t.string   "title_states"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.string   "heading"
    t.string   "codetype"
    t.string   "body"
    t.string   "done"
    t.string   "name"
    t.string   "user"
    t.string   "sessionId"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "nickname"
    t.string   "user_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
