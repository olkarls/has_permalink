require 'rails/generators/active_record'

class HasPermalinkGenerator < ActiveRecord::Generators::Base
  desc "Create a migration to add a permalink field to your model."
  argument :model_name, :type => :string, :required => true, :desc => "The model you want to add a permalink to"
  
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end
  
  def generate_migration
    migration_template "has_permalink_migration.rb.erb", "db/migrate/#{migration_file_name}"
  end
  
  protected

  def migration_name
    "add_permalink_to_#{model_name.underscore}"
  end

  def migration_file_name
    "#{migration_name}.rb"
  end

  def migration_class_name
    migration_name.camelize
  end
end