lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "watir_api"
  spec.version       = "0.1.0"
  spec.authors       = ["Titus Fortner"]
  spec.email         = ["titusfortner@gmail.com"]

  spec.summary       = %q{A simple class for interacting with a Web App's API using test data}
  spec.description   = %q{Send and receive data via a Web App's API, ideally using WatirModel objects. The goal is to
compare test data with what is input and displayed via UI.}
  spec.homepage      = "https://github.com/titusfortner/watir_api"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'watir_model'#, '~> 0.4.2'
  spec.add_runtime_dependency "faker", "~> 1.5"
  spec.add_runtime_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "watir", "~> 6.9"
  spec.add_development_dependency "webdrivers", "~> 3.0"
  spec.add_development_dependency "require_all"
end
