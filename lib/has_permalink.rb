require 'friendly_url'

module HasPermalink
  require 'railtie' if defined?(Rails)

  def has_permalink(generate_from = :title)
    unless included_modules.include? InstanceMethods
      class_inheritable_accessor :generate_from
      extend ClassMethods
      include InstanceMethods
    end

    self.generate_from = generate_from
    before_validation :generate_permalink
  end

  module ClassMethods
    def generate_permalinks
      self.all.each do |item|
        item.generate_permalink
        item.save
      end
    end
  end

  module InstanceMethods
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