# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'ruby-perlin-2D-map-generator'
  s.version     = '0.0.1'
  s.summary     = 'Generate 2D maps, rendered with ansi colours or described in a hash'
  s.description = 'A gem that generates a 2D map using perlin noise. Map can be rendered in console ' \
                  'using ansi colors or returned as a hash describing each tile and binome. Completely' \
                  'customizable, use the --help option for full usage details.'
  s.authors     = ['Tyler Matthews (matthewstyler)']
  s.email       = 'matthews.tyl@gmail.com'
  s.files       = `git ls-files bin lib *.md LICENSE`.split("\n")
  s.license     = 'MIT'
  s.executables   = ['ruby-perlin-2D-map-generator']
  s.require_paths = ['lib']

  s.add_dependency 'perlin'
  s.add_dependency 'tty-option'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
end
