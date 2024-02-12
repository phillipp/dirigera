require_relative 'lib/dirigera/version'

Gem::Specification.new do |s|
  s.name        = 'dirigera'
  s.version     = Dirigera::VERSION
  s.licenses    = ['MIT']
  s.required_ruby_version = '>= 2.7.0'
  s.summary     = "API client for the IKEA Dirigera hub using a local connection"
  s.authors     = ["Phillipp Röll"]
  s.email       = 'phillipp.roell@trafficplex.de'
  s.files       = ["lib/dirigera.rb"]
  s.homepage    = 'https://rubygems.org/gems/dirigera'
  s.metadata    = { "source_code_uri" => "https://github.com/phillipp/dirigera" }

  s.add_dependency 'httparty'
end
