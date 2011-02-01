namespace :has_permalink do
  desc 'Generate permalinks for [MODEL]'
  task :generate_permalinks, :model_name, :needs => :environment do |t, args|
    begin
      model_name = args.first[1]
    rescue
      puts "ERROR: You need to pass the name of the model as an argument."
      puts "Try this: 'rake has_permalink:generate_permalinks[MODEL]'"
    else
      generate_permalinks(model_name)
    end
  end
end

def generate_permalinks(model_name)
  begin
    if Kernel.const_get(model_name)
      model_name.constantize.generate_permalinks
      puts "Congratulations! '#{model_name}' has permalinks!"
    end
  rescue
    puts "Can't find model '#{model_name}'. Does it exist?"
  end
end