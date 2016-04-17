Gem::Specification.new do |gem|
  gem.author  = 'Ola Karlsson'
  gem.email   = 'olkarls@gmail.com'
  gem.name    = 'has_permalink'
  gem.version = '0.1.7'
  gem.summary = 'SEO Permalink Plugin for Ruby on Rails.'
  gem.files = Dir['lib/**/*', 'rails/**/*']
  gem.homepage = 'http://haspermalink.org'
  gem.add_runtime_dependency 'activerecord', '>= 2.0.0'
  gem.add_development_dependency 'simplecov', '>= 0.11.2'
  gem.add_development_dependency 'sqlite3', '>= 1.0'
end
