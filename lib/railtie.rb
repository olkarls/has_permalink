require 'has_permalink'
require 'rails'

module HasPermalink
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/has_permalink.rake'
    end
  end
end