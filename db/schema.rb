# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20140307132033) do

  create_table "competitions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.boolean  "published"
  end

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "number_of_problems"
    t.string   "tarball_file_name"
    t.string   "tarball_content_type"
    t.integer  "tarball_file_size"
    t.datetime "tarball_updated_at"
    t.string   "status"
    t.text     "plain_text"
  end

  create_table "experiments", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "domain_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "problem_id"
  end

  create_table "hosts", :force => true do |t|
    t.string   "ip_address"
    t.boolean  "trusted"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "planner_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "planners", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "tarball_file_name"
    t.string   "tarball_content_type"
    t.integer  "tarball_file_size"
    t.datetime "tarball_updated_at"
    t.string   "status"
  end

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.integer  "problem_number"
    t.text     "plain_text"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "domain_id"
  end

  create_table "results", :force => true do |t|
    t.integer  "result_number"
    t.integer  "quality"
    t.text     "output"
    t.text     "validation_output"
    t.integer  "task_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.boolean  "valid_plan"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "experiment_id"
    t.string   "status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "host_id"
    t.text     "output"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "organiser"
    t.boolean  "admin"
  end

end
