module HasPermalink
  class Utilities
    attr_accessor :model_name, :klass

    def initialize(model_name)
      @model_name = model_name
      @klass = self.get_class
    end

    def get_class
      if @model_name.include?('::')
        @model_name.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      else
        Object.const_get(@model_name)
      end
    end

    def generate_permalinks
      @klass.generate_permalinks
    end
  end
end