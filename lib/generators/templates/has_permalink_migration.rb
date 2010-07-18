class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    add_column :<%= model_name.underscore.camelize.tableize %>, :permalink, :string
    add_index :<%= model_name.underscore.camelize.tableize %>, :permalink
  end
  def self.down
    remove_column :<%= model_name.underscore.camelize.tableize %>, :permalink
  end
end