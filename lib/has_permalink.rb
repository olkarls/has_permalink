require 'friendly_url'

module HasPermalink
  def has_permalink(generate_from = :title)
    unless included_modules.include? Behavior
      class_inheritable_accessor :generate_from
      include Behavior
    end

    self.generate_from = generate_from
    before_validation :generate_permalink
  end
  
  module Behavior
    include FriendlyUrl
    def generate_permalink
      self.permalink = normalize(self.send(generate_from)) if permalink.blank?
    end
    
    def generate_permalink!
      self.permalink = normalize(self.send(generate_from))
    end
    
    def to_param
      permalink
    end
  end
end

ActiveRecord::Base.send :extend, HasPermalink