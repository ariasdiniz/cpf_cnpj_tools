# CpfCnpjTools

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cpf_cnpj_tools`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cpf_cnpj_tools

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cpf_cnpj_tools

## Usage

For usage, import the gem and create a new instance of it:

```ruby
require "cpf_cnpj_tools"

generate = CpfCnpjTools::Generator.new

puts generate.generate_cpf # returns a valid CPF
puts generate.generate_cnpj # returns a valid cnpj
puts generate.validate_cpf("999999900") # validate returning true or false
puts generate.validate_cnpj("99999999000100") # validate returning true or false
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ariasdiniz/cpf_cnpj_tools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ariasdiniz/cpf_cnpj_tools/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CpfCnpjTools project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ariasdiniz/cpf_cnpj_tools/blob/main/CODE_OF_CONDUCT.md).
