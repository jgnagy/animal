# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'animal/version'

Gem::Specification.new do |spec|
  spec.name          = 'animal'
  spec.version       = Animal::VERSION
  spec.authors       = ['Daniel Schaaff', 'Jonathan Gnagy']
  spec.email         = ['jgnagy@knuedge.com']

  spec.summary       = 'Animal Puppet ENC'
  spec.description   = 'Animal Puppet External Node Classifier'
  spec.homepage      = 'https://github.com/knuedge/animal'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['yard.run'] = 'yri'
  spec.required_ruby_version = '~> 2.2'
  spec.post_install_message  = 'Thanks for installing Animal!'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'travis', '~> 1.8'
  spec.add_development_dependency 'simplecov'
end
