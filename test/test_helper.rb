# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cpf_cnpj_tools"

require "minitest/autorun"

class Testing < Minitest::Test
  def test_cpf
    gen = CpfCnpjTools::Generator.new
    cpf = gen.generate_cpf
    assert(gen.cpf_valid?(cpf))
  end

  def test_invalid_cpf
    gen = CpfCnpjTools::Generator.new
    assert(!gen.cpf_valid?("99999999900"))
  end

  def test_cnpj
    gen = CpfCnpjTools::Generator.new
    cnpj = gen.generate_cnpj
    assert(gen.cnpj_valid?(cnpj))
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
    cpf = gen.generate_cpf
    cnpj = gen.generate_cnpj
    assert(!gen.formatted?(cpf))
    assert(!gen.formatted?(cnpj))
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
