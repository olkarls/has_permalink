require 'friendly_url'

module HasPermalink
  require 'railtie' if defined?(Rails) && Rails.version >= "3"

  def has_permalink(generate_from = :title, auto_fix_duplication = false)
    unless included_modules.include? InstanceMethods
      class_attribute :generate_from
      class_attribute :auto_fix_duplication
      extend ClassMethods
      include InstanceMethods
    end

    self.generate_from        = generate_from
    self.auto_fix_duplication = auto_fix_duplication
    before_validation :generate_permalink
  end

  module ClassMethods
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
      self.permalink = fix_duplication(normalize(self.send(generate_from))) if permalink.blank?
    end

    # Generate permalink for the instance and overwrite any existing value.
    def generate_permalink!
      self.permalink = fix_duplication(normalize(self.send(generate_from)))
    end

    # Override to send permalink as params[:id]
    def to_param
      permalink
    end

    private

    # Autofix duplication of permalinks
    def fix_duplication(permalink)
      if auto_fix_duplication
        n = if id.present?
          self.class.where(["permalink = ? AND id != ?", permalink, id]).count
        else
          self.class.where(["permalink = ?", permalink]).count
        end

        if n > 0
          links = self.class.where(["permalink LIKE ?", "#{permalink}%"]).order("id")

          number = 0

          links.each_with_index do |link, index|
            if link.permalink =~ /#{permalink}-\d*\.?\d+?$/
              new_number = link.permalink.match(/-(\d*\.?\d+?)$/)[1].to_i
              number = new_number if new_number > number
            end
          end
          resolve_duplication(permalink, number + 1)
        else
          permalink
        end
      else
        permalink
      end
    end

    def resolve_duplication(permalink, number)
      "#{permalink}-#{number}"
    end
  end
end

ActiveRecord::Base.send :extend, HasPermalink
