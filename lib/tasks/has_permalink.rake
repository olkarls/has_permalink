require 'utilities'

namespace :has_permalink do
  desc 'Generate permalinks for [MODEL]'
  task :generate_permalinks, [:model_name] => [:environment] do |t, args|
    begin
      model_name = args.first[1]
    rescue
      puts "ERROR: You need to pass the name of the model as an argument."
      puts "Try this: 'rake has_permalink:generate_permalinks[MODEL]'"
    else
      util = HasPermalink::Utilities.new(model_name)
      util.generate_permalinks
      puts "Congratulations! '#{model_name}' has permalinks!"
    end
  end
end