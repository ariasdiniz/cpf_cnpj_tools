# frozen_string_literal: true

require_relative "cpf_cnpj_tools/version"
require_relative "invalid_cpf_cnpj_format_exception"

module CpfCnpjTools
  ##
  # Class responsible for generating and
  # validating CPF and CNPJ numbers
  class Generator
    CPF1DIGIT = [10, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    CPF2DIGIT = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    CNPJ1DIGIT = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    CNPJ2DIGIT = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze

    ##
    # Method for generating valid CPF numbers
    # @param {Boolean} formatted
    # @return String
    def generate_cpf(formatted: true)
      base = generate_base
      base << generate_identifier(base, true)
      base << generate_identifier(base, false)
      return base.join unless formatted

      format(base.join)
    end

    ##
    # Method for generating valid CNPJ numbers
    # @param {Boolean} formatted
    # @return String
    def generate_cnpj(formatted: true)
      base = generate_base(cnpj: true)
      base << generate_identifier(base, true, cpf: false)
      base << generate_identifier(base, false, cpf: false)
      return base.join unless formatted

      format(base.join)
    end

    ##
    # Method for validating CPF numbers.
    # @param {String, Integer} cpf
    # @return bool
    def cpf_valid?(cpf)
      cpf_array = remove_formatting(cpf.to_s).split("").map!(&:to_i)
      first_digit = cpf_array[-2]
      second_digit = cpf_array[-1]
      base_cpf = cpf_array[0..8]
      calculated_first_digit = generate_identifier(base_cpf, true)
      calculated_second_digit = generate_identifier(base_cpf << calculated_first_digit, false)
      return false if (first_digit != calculated_first_digit) || (second_digit != calculated_second_digit)

      true
    end

    ##
    # Method for validating CNPJ numbers.
    # @param {Integer, String} cpf
    # @return bool
    def cnpj_valid?(cnpj)
      cnpj_array = remove_formatting(cnpj.to_s).split("").map!(&:to_i)
      first_digit = cnpj_array[-2]
      second_digit = cnpj_array[-1]
      base_cnpj = cnpj_array[0..11]
      calculated_first_digit = generate_identifier(base_cnpj, true, cpf: false)
      calculated_second_digit = generate_identifier(base_cnpj << calculated_first_digit, false, cpf: false)
      return false if (first_digit != calculated_first_digit) || (second_digit != calculated_second_digit)

      true
    end

    ##
    # Return true if the CPF/CNPJ is formatted.
    # Return false if not.
    # @param {String, Integer} cpf_or_cnpj
    # @return bool
    def formatted?(cpf_or_cnpj)
      number = cpf_or_cnpj.to_s
      return true if (number =~ /\d{3}\.\d{3}\.\d{3}-\d{2}/) || (number =~ %r{\d{2}\.\d{3}\.\d{3}/0001-\d{2}})

      false
    end

    ##
    # Returns an unformatted CPF or CNPJ.
    # If the value is already unformatted,
    # the method returns the value passed as argument.
    # @param {String, Integer} cpf_or_cnpj
    # @return String
    def remove_formatting(cpf_or_cnpj)
      unformatted = cpf_or_cnpj.to_s.delete("./-")
      return unformatted unless unformatted.nil?

      cpf_or_cnpj.to_s
    end

    ##
    # Returns a String containing a formatted CPF/CNPJ.
    # @param {String, Integer} cpf_or_cnpj
    # @return String
    def format(cpf_or_cnpj)
      if cpf_valid?(cpf_or_cnpj)
        cpf = cpf_or_cnpj.to_s.dup
        cpf.insert(3, ".")
           .insert(7, ".")
           .insert(-3, "-")
      elsif cnpj_valid?(cpf_or_cnpj)
        cnpj = cpf_or_cnpj.to_s.dup
        cnpj.insert(2, ".")
            .insert(6, ".")
            .insert(10, "/")
            .insert(-3, "-")
      else
        raise InvalidCpfCnpjFormatError
      end
    end

    private

    ##
    # Generate the first numbers of CPF/CNPJ
    # randomly.
    # @param cnpj (Boolean)
    # @return (Array)
    def generate_base(cnpj: false)
      base_number = []
      9.times do
        base_number << rand(10)
      end
      if cnpj
        base_number.delete_at(-1)
        base_number.push 0, 0, 0, 1
      end
      base_number
    end

    ##
    # Generate the first and second identifier numbers
    # of the CPF/CNPJ.
    # @param first_numbers (Array)
    # @param first (Boolean)
    # @param cpf (Boolean)
    # @return Integer
    def generate_identifier(first_numbers, first, cpf: true)
      multipliers = if cpf
                      first ? CPF1DIGIT : CPF2DIGIT
                    else
                      first ? CNPJ1DIGIT : CNPJ2DIGIT
                    end
      product = []
      first_numbers.length.times do |index|
        product << first_numbers[index] * multipliers[index]
      end
      generate_valid_digit(product)
    end

    ##
    # Calculates the value of a valid identifier digit.
    # @param digits (Array)
    # @return Integer
    def generate_valid_digit(digits)
      sum = 0
      digits.each do |item|
        sum += item
      end
      remainder = sum % 11
      if remainder < 2
        0
      else
        11 - remainder
      end
    end
  end
end
