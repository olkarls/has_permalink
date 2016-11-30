Gem::Specification.new do |gem|
  gem.author  = 'Ola Karlsson'
  gem.email   = 'olkarls@gmail.com'
  gem.name    = 'has_permalink'
  gem.version = '0.1.8'
  gem.summary = 'SEO Permalink Plugin for Ruby on Rails.'
  gem.files = Dir['lib/**/*', 'rails/**/*']
  gem.homepage = 'http://haspermalink.org'
  gem.licenses = ['MIT']
  gem.add_runtime_dependency 'activerecord', '~> 4.0', '>= 2.0.0'
  gem.add_development_dependency 'simplecov', '~> 0.11', '>= 0.11.2'
  gem.add_development_dependency 'coveralls', '~> 0.8.13', '>= 0.8.13'
  gem.add_development_dependency 'sqlite3', '~> 1.0'
  gem.add_development_dependency 'pry-byebug', '>= 3.4.0'
end
