require 'friendly_url'

module HasPermalink
  def has_permalink(options = {})
    options[:field_to_generate]       ||= "permalink"
    options[:field_to_generate_from]  ||= "title"

    unless included_modules.include? Behavior
      class_inheritable_accessor :options
      include Behavior
    end

    self.options = options
    before_validation :generate_permalink
  end
  
  module Behavior
    include FriendlyUrl
    def generate_permalink
      if permalink.blank?
        self.permalink = normalize(eval("self.#{options[:field_to_generate_from]}"))
      end
    end
    
    def to_param
      permalink
    end
  end
end

ActiveRecord::Base.send :extend, HasPermalink