# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tcs-motion/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'TCSMotion'
  spec.version       = TCS_MOTION::VERSION
  spec.authors       = ['Chris Crawford', 'Todd Stout']
  spec.email         = %w(chris.a.crawford@gmail.com btstout@containerstore.com)
  spec.description   = %q{CollectionViews, MenuViews and other useful stuff}
  spec.summary       = %q{TCS Controls for RubyMotion}
  spec.homepage      = 'http://www.containerstore.com'

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib motion)

  spec.add_dependency 'bubble-wrap', '~> 1.4.0'
  spec.add_dependency 'sugarcube', '~> 1.0.1'
  spec.add_development_dependency 'motion-stump', '~> 0.3.0'
end
