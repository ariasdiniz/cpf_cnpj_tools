# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "cpf_cnpj_tools"

require "minitest/autorun"

class Testing < Minitest::Test
  def test_cpf
    gen = CpfCnpjTools::Generator.new
    cpf = gen.generate_cpf
    assert(gen.validate_cpf(cpf))
  end

  def test_invalid_cpf
    gen = CpfCnpjTools::Generator.new
    assert(!gen.validate_cpf("99999999900"))
  end

  def test_cnpj
    gen = CpfCnpjTools::Generator.new
    cnpj = gen.generate_cnpj
    assert(gen.validate_cnpj(cnpj))
  end

  def test_invalid_cnpj
    gen = CpfCnpjTools::Generator.new
    assert(!gen.validate_cnpj("12345678912345"))
  end
end
