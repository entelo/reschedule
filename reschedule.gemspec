require File.expand_path('../lib/reschedule/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Tom Benner']
  s.email         = ['tombenner@gmail.com']
  s.description = s.summary = %q{reschedule}
  s.homepage      = 'https://github.com/EnteloEngineering/reschedule'

  s.files         = `git ls-files`.split($\)
  s.name          = 'reschedule'
  s.require_paths = ['lib']
  s.version       = Reschedule::VERSION
  s.license       = 'MIT'

  s.add_dependency 'activesupport'
  s.add_dependency 'httparty'
  s.add_dependency 'kubeclient', '>= 0.9.0'
  s.add_dependency 'rufus-scheduler'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
end
