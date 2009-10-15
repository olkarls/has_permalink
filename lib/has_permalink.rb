module HasPermalink
  def has_permalink(options = {})
    options[:field_to_generate]       ||= "permalink"
    options[:field_to_generate_from]  ||= "title"
    
    unless included_modules.include? Behavior
      class_inheritable_accessor :options
      include Behavior
    end
    
    #validates_presence_of options[:field_to_generate_from].to_symbol, options[:field_to_generate_from].to_symbol
    #validates_uniqueness_of options[:field_to_generate_from].to_symbol, :case_insensitive => true
    
    validates_presence_of :title, :permalink
    validates_uniqueness_of :permalink, :case_insensitive => true               
    before_validation :generate_permalink    
  end
  
  module Behavior
    include FriendlyUrl    
    def generate_permalink
      if @permalink.blank?
        self.permalink = normalize(self.title)
      end
    end
    
    def to_param
      permalink
    end
  end
end