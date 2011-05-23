require 'friendly_url'

module HasPermalink
  require 'railtie' if defined?(Rails) && Rails.version >= "3"

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

    # find(params[:id]) is quering the permalink field if it's a string
    #
    def find(*args)
      find_by_permalink!(args)
    end

    # Makes it possible to generate permalinks for
    # all instances of self:
    #
    #   Product.generate_permalinks
    #
    def generate_permalinks
      self.all.each do |item|
        item.generate_permalink
        item.save
      end
    end
  end

  module InstanceMethods
    include FriendlyUrl

    # Generate permalink for the instance if the permalink is empty or nil.
    def generate_permalink
      self.permalink = normalize(self.send(generate_from)) if permalink.blank?
    end

    # Generate permalink for the instance and overwrite any existing value.
    def generate_permalink!
      self.permalink = normalize(self.send(generate_from))
    end

    # Override to send permalink as params[:id]
    def to_param
      permalink
    end
  end
end

ActiveRecord::Base.send :extend, HasPermalink