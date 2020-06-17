require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name          = "countonce-ruby"
  spec.version       = CountOnce::VERSION
  spec.authors       = ["dummy_author"]
  spec.email         = ["dummy_email@dummy_domain.com"]

  spec.summary       = %q{Wrapper for the CountOnce API}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  # dependencies
  spec.add_dependency "httparty", "~> 0.18.0"
  spec.add_dependency "concurrent-ruby", "~> 1.1.6"
end
