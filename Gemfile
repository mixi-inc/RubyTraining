source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'slim'
gem 'activerecord', '>= 3.1', :require => 'active_record'
gem 'mysql2'

# Test requirements
group :development, :test do
  gem 'rspec', '~> 3.0.0.beta'
  gem 'rack-test', :require => 'rack/test'
end

# Padrino Stable Gem
gem 'padrino', '0.12.0'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.0'
# end
