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
    assert(!gen.cpf_valid?("123456789012"))
    assert(!gen.cpf_valid?("1234567890"))
    assert(!gen.cpf_valid?("123A5678901"))
  end

  def test_cnpj_numeric
    gen = CpfCnpjTools::Generator.new
    cnpj = gen.generate_cnpj(alphanumeric: false)
    assert(gen.cnpj_valid?(cnpj))
    assert(gen.cnpj_valid?(gen.format(cnpj)))
  end

  def test_cnpj_alphanumeric
    gen = CpfCnpjTools::Generator.new
    cnpj = gen.generate_cnpj(alphanumeric: true)
    assert(gen.cnpj_valid?(cnpj))
    assert(gen.cnpj_valid?(gen.format(cnpj)))

    lowercase_cnpj = cnpj.downcase
    assert(gen.cnpj_valid?(lowercase_cnpj))
  end

  def test_invalid_cnpj
    gen = CpfCnpjTools::Generator.new
    assert(!gen.cnpj_valid?("12345678912345"))
    assert(!gen.cnpj_valid?("A1B2C3D4E5F67A"))
    assert(!gen.cnpj_valid?("1234567891234"))
    assert(!gen.cnpj_valid?("123456789123456"))
  end

  def test_formatted_cpf_cnpj
    gen = CpfCnpjTools::Generator.new
    cpf = "100.100.100-10"
    cnpj_num = "10.100.100/0001-10"
    cnpj_alpha = "A1.B2C.3D4/E5F6-78"

    assert(gen.formatted?(cpf))
    assert(gen.formatted?(cnpj_num))
    assert(gen.formatted?(cnpj_alpha))

    assert(!gen.formatted?("10010010010"))
    assert(!gen.formatted?("10100100000110"))
    assert(!gen.formatted?("A1B2C3D4E5F678"))
  end

  def test_unformatted_cpf_cnpj
    gen = CpfCnpjTools::Generator.new
    cpf = gen.generate_cpf(formatted: false)
    cnpj_num = gen.generate_cnpj(formatted: false, alphanumeric: false)
    cnpj_alpha = gen.generate_cnpj(formatted: false, alphanumeric: true)

    assert(!gen.formatted?(cpf))
    assert(!gen.formatted?(cnpj_num))
    assert(!gen.formatted?(cnpj_alpha))
  end

  def test_format_cpf_cnpj
    gen = CpfCnpjTools::Generator.new

    valid_cpf = "57477136717"
    valid_cnpj_num = "52905095000196"

    assert_equal("574.771.367-17", gen.format(valid_cpf))
    assert_equal("52.905.095/0001-96", gen.format(valid_cnpj_num))

    valid_cnpj_alpha = gen.generate_cnpj(formatted: false, alphanumeric: true)
    formatted_alpha = gen.format(valid_cnpj_alpha)
    assert_match(%r{^[A-Z0-9]{2}\.[A-Z0-9]{3}\.[A-Z0-9]{3}/[A-Z0-9]{4}-\d{2}$}, formatted_alpha)

    valid_cnpj_alpha_lower = valid_cnpj_alpha.downcase
    formatted_alpha_upper = gen.format(valid_cnpj_alpha_lower)
    assert_match(%r{^[A-Z0-9]{2}\.[A-Z0-9]{3}\.[A-Z0-9]{3}/[A-Z0-9]{4}-\d{2}$}, formatted_alpha_upper)

    assert_raises(InvalidCpfCnpjFormatError) do
      gen.format("99999999900")
    end
    assert_raises(InvalidCpfCnpjFormatError) do
      gen.format("52905095000100")
    end
    assert_raises(InvalidCpfCnpjFormatError) do
      gen.format("A1B2C3D4E5F678")
    end
  end

  def test_unformat_cpf_cnpj
    gen = CpfCnpjTools::Generator.new

    cpf = "999.999.999-99"
    cnpj_num = "99.999.999/0001-99"
    cnpj_alpha = "A1.B2C.3D4/E5F6-78"
    unformatted_value = "99999999999"

    assert_equal("99999999999", gen.remove_formatting(cpf))
    assert_equal("99999999000199", gen.remove_formatting(cnpj_num))
    assert_equal("A1B2C3D4E5F678", gen.remove_formatting(cnpj_alpha))
    assert_equal("99999999999", gen.remove_formatting(unformatted_value))
  end

  def test_generate_array_of_valid_cpfs
    gen = CpfCnpjTools::Generator.new
    array = gen.generate_array_of_cpf(10)
    assert_equal(10, array.length)
    array.each do |item|
      assert(gen.cpf_valid?(item))
    end
  end

  def test_generate_array_of_valid_cnpjs
    gen = CpfCnpjTools::Generator.new

    array_num = gen.generate_array_of_cnpj(5, alphanumeric: false)
    assert_equal(5, array_num.length)
    array_num.each do |item|
      assert(gen.cnpj_valid?(item))
    end

    array_alpha = gen.generate_array_of_cnpj(5, alphanumeric: true)
    assert_equal(5, array_alpha.length)
    array_alpha.each do |item|
      assert(gen.cnpj_valid?(item))
    end
  end
end
