# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'ruby-perlin-2D-map-generator'
  s.version       = '0.0.1'
  s.summary       = 'Procedurally generate seeded and customizable 2D maps, rendered with ansi colours or described in a 2D array of hashes'
  s.description   = 'A gem that procedurally generates a seeded and customizable 2D map using perlin noise. Map can be rendered in console ' \
                    'using ansi colors or returned as 2D array of hashes describing each tile and binome. Completely' \
                    'customizable, use the --help option for full usage details.'
  s.authors       = ['Tyler Matthews (matthewstyler)']
  s.email         = 'matthews.tyl@gmail.com'
  s.files         = `git ls-files bin lib *.md LICENSE`.split("\n")
  s.license       = 'MIT'
  s.executables   = ['ruby-perlin-2D-map-generator']
  s.require_paths = ['lib']

  s.homepage                    = 'https://github.com/matthewstyler/ruby-perlin-2D-map-generator'
  s.metadata['source_code_uri'] = 'https://github.com/matthewstyler/ruby-perlin-2D-map-generator'
  s.metadata['bug_tracker_uri'] = 'https://github.com/matthewstyler/ruby-perlin-2D-map-generator/issues'

  s.add_dependency 'perlin'
  s.add_dependency 'tty-option'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
end
