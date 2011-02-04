require 'has_permalink'
require 'rails'

module HasPermalink
  class Railtie < Rails::Railtie

    # Include the rake tasks to the application with the gem installed
    rake_tasks do
      load 'tasks/has_permalink.rake'
    end
  end
end