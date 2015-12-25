require File.expand_path('../lib/reschedule/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Tom Benner']
  s.email         = ['tombenner@gmail.com']
  s.description = s.summary = %q{TODO}
  s.homepage      = 'https://github.com/tombenner/reschedule'

  s.files         = `git ls-files`.split($\)
  s.name          = 'reschedule'
  s.require_paths = ['lib']
  s.version       = Reschedule::VERSION
  s.license       = 'MIT'

  s.add_development_dependency 'rspec'
end
