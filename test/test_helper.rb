# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cpf_cnpj_tools"
require "invalid_cpf_cnpj_format_exception"

require "minitest/autorun"

class Testing < Minitest::Test
  def test_cpf
    gen = CpfCnpjTools::Generator.new
    cpf = gen.generate_cpf
    assert(gen.cpf_valid?(cpf))
    assert(gen.cpf_valid?(gen.format(cpf)))
  end

  def test_invalid_cpf
    gen = CpfCnpjTools::Generator.new
    assert(!gen.cpf_valid?("99999999900"))
  end

  def test_cnpj
    gen = CpfCnpjTools::Generator.new
    cnpj = gen.generate_cnpj
    assert(gen.cnpj_valid?(cnpj))
    assert(gen.cnpj_valid?(gen.format(cnpj)))
  end

  def test_invalid_cnpj
    gen = CpfCnpjTools::Generator.new
    assert(!gen.cnpj_valid?("12345678912345"))
  end

  def test_formated_cpf_cnpj
    gen = CpfCnpjTools::Generator.new
    cpf = "100.100.100-10"
    cnpj = "10.100.100/0001-10"
    assert(gen.formatted?(cpf))
    assert(gen.formatted?(cnpj))
  end

  def test_unformatted_cpf_cnpj
    gen = CpfCnpjTools::Generator.new
    cpf = gen.generate_cpf(formatted: false)
    cnpj = gen.generate_cnpj(formatted: false)
    assert(!gen.formatted?(cpf))
    assert(!gen.formatted?(cnpj))
  end

  def test_format_cpf_cnpj
    gen = CpfCnpjTools::Generator.new
    valid_cpf = "57477136717"
    valid_cnpj = "52905095000196"
    wrong_cpf = "99999999900"
    wrong_cnpj = "52905095000100"
    assert(gen.format(valid_cpf) == "574.771.367-17")
    assert(gen.format(valid_cnpj) == "52.905.095/0001-96")
    assert_raises(InvalidCpfCnpjFormatError) do
      gen.format(wrong_cnpj)
    end
    assert_raises(InvalidCpfCnpjFormatError) do
      gen.format(wrong_cpf)
    end
  end

  def test_unformat_cpf_cnpj
    gen = CpfCnpjTools::Generator.new
    cpf = "999.999.999-99"
    cnpj = "99.999.999/0001-99"
    unformatted_value = "99999999999"
    assert(gen.remove_formatting(cpf) == "99999999999")
    assert(gen.remove_formatting(cnpj) == "99999999000199")
    assert(gen.remove_formatting(unformatted_value) == "99999999999")
  end
end
