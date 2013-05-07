namespace :has_permalink do
  desc 'Generate permalinks for [MODEL]'
  task :generate_permalinks, [:model_name] => [:environment] do |t, args|
    begin
      model_name = args.first[1]
    rescue
      puts "ERROR: You need to pass the name of the model as an argument."
      puts "Try this: 'rake has_permalink:generate_permalinks[MODEL]'"
    elsif model_name.include?("::")  # Generating permalinks for class inside a module For e.g "ActsAsTaggableOn::Tag"
      get_class_and_generate_permalink(model_name)      
    else
      generate_permalinks(model_name)
    end
  end
end

# Calls the class method 'generate_permalinks' on given model
def generate_permalinks(model_name)
  begin
    if Kernel.const_get(model_name)
      model_name.constantize.generate_permalinks
      puts "Congratulations! '#{model_name}' has permalinks!"
    end
  rescue
    rescue_error(model_name)
  end
end


def get_class_and_generate_permalink(model_name)
  begin
  @model_name=model_name.split("::").inject(Object) do |mod,class_name|
    mod.const_get(class_name)
  end
  @model_name.generate_permalinks  # adding permalink attribute for existing table
  puts "Congratulations! '#{model_name}' has permalinks!"
   rescue
    rescue_error(model_name)
  end
end

def rescue_error(model_name)
   puts "Can't find model '#{model_name}'. Does it exist?"
end