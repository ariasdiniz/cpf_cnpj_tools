# frozen_string_literal: true

require_relative "lib/cpf_cnpj_tools/version"

Gem::Specification.new do |spec|
  spec.name = "cpf_cnpj_tools"
  spec.version = CpfCnpjTools::VERSION
  spec.authors = ["Aria Diniz"]
  spec.email = ["aria.diniz.dev@gmail.com"]

  spec.summary = "A tool for generating and validating CPF/CNPJ numbers"
  spec.description = "With this tool you will be able to generate and validate brazilian CPF and CNPJ numbers."
  spec.homepage = "https://github.com/ariasdiniz/cpf_cnpj_tools"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6"

  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/cpf_cnpj_tools"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ariasdiniz/cpf_cnpj_tools"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
