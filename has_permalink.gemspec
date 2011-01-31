Gem::Specification.new do |gem|
  gem.author  = 'Ola Karlsson'
  gem.email   = 'olkarls@gmail.com'
  gem.name    = 'has_permalink'
  gem.version = '0.0.6'
  gem.summary = 'Generating url-safe permalink from any other attribute in the same ActiveRecord model.'
  gem.files = Dir['lib/**/*', 'rails/**/*']
  gem.add_dependency 'rails', '>= 3.0.0.beta4'
end