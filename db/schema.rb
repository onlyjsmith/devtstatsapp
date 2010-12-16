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

ActiveRecord::Schema.define(:version => 20101216155454) do

  create_table "devtcharges", :force => true do |t|
    t.string  "year",       :limit => 45
    t.string  "grossdevt",  :limit => 45
    t.string  "recovered",  :limit => 45
    t.string  "netdevt",    :limit => 45
    t.integer "project_id",               :null => false
  end

  add_index "devtcharges", ["project_id"], :name => "fk_devtcharges_projects1"

  create_table "funders", :force => true do |t|
    t.string  "name",       :limit => 45
    t.string  "category",   :limit => 45
    t.integer "project_id",               :null => false
  end

  add_index "funders", ["project_id"], :name => "fk_funders_projects1"

  create_table "pipelines", :force => true do |t|
    t.integer "year"
    t.integer "month"
    t.text    "stage",      :limit => 255
    t.text    "lead",       :limit => 255
    t.text    "programme",  :limit => 255
    t.text    "funder"
    t.string  "budget",     :limit => 30
    t.string  "stafftime",  :limit => 30
    t.integer "project_id",                :null => false
  end

  add_index "pipelines", ["project_id"], :name => "fk_pipelines_projects1"

  create_table "projects", :force => true do |t|
    t.string "number", :limit => 45
    t.text   "title"
  end

end
