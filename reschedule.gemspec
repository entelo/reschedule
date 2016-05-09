require File.expand_path('../lib/reschedule/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Tom Benner']
  s.email         = ['tombenner@gmail.com']
  s.description = s.summary = %q{Automatic, configurable Kubernetes rescheduling}
  s.homepage      = 'https://github.com/entelo/reschedule'

  s.files         = `git ls-files`.split($\)
  s.name          = 'reschedule'
  s.require_paths = ['lib']
  s.version       = Reschedule::VERSION
  s.license       = 'MIT'

  s.add_dependency 'activesupport', '~> 4.2'
  s.add_dependency 'httparty', '~> 0.13'
  s.add_dependency 'kubeclient', '~> 0.9.0'
  s.add_dependency 'rufus-scheduler', '~> 3.2'

  s.add_development_dependency 'hashie', '~> 3.4'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 1.8'
end
