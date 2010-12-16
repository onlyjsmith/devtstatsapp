class Buildtable < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table "devtcharges"
    drop_table "funders"
    drop_table "pipelines"
    drop_table "projects"
  end
end
