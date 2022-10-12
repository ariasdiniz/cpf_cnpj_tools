# frozen_string_literal: true

##
# Error raised when trying to format
# an invalid CPF or CNPJ.
class InvalidCpfCnpjFormatError < StandardError
  def initialize(msg = "Invalid CPF or CNPJ.")
    super
  end
end
