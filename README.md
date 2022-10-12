# CpfCnpjTools

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
puts generate.cpf_valid?("999999900") # validate returning true or false
puts generate.cnpj_valid?("99999999000100") # validate returning true or false
puts generate.formatted?("99999999900") # validate if cpf/cnpj is formatted returning true or false
puts generate.format("16255648800") # return the formatted cpf/cnpj. Ex: 162.556.488-00
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ariasdiniz/cpf_cnpj_tools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ariasdiniz/cpf_cnpj_tools/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CpfCnpjTools project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ariasdiniz/cpf_cnpj_tools/blob/main/CODE_OF_CONDUCT.md).
