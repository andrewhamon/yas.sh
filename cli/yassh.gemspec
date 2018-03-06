Gem::Specification.new do |s|
  s.name        = 'yassh'
  s.version     = '0.0.2'
  s.date        = '2018-01-27'
  s.summary     = "yassh push ."
  s.description = "Publish a folder instantly to yas.sh"
  s.authors     = ["Andrew Hamon"]
  s.email       = 'andrew@hamon.cc'
  s.executables << 'yassh'
  s.homepage    = 'http://rubygems.org/gems/yassh'
  s.license     = 'MIT'
  s.add_runtime_dependency "commander", ["~> 4.4"]
  s.add_runtime_dependency "mimemagic", ["~> 0.3.2"]
  s.add_runtime_dependency "rest-client", ["~> 2.0"]
end
