Gem::Specification.new do |spec|
  spec.name          = 'cando'
  spec.version       = '0.2'
  spec.summary       = %{Simple authorization framework for Rails.}
  spec.description   = %{Simple authorization using existing helper methods.}

  spec.author        = 'Krugloff'
  spec.email         = 'mr.krugloff@gmail.com'
  spec.license       = 'MIT'
  spec.homepage      = 'http://github.com/Krugloff/cando'

  spec.files         = Dir["{lib,test}/**/*", "[A-Z]*"]
  spec.test_files    = 'test'
  spec.require_path  = 'lib'
end
