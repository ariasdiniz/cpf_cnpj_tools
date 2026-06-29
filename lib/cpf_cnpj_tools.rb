# frozen_string_literal: true

require_relative "cpf_cnpj_tools/version"
require_relative "invalid_cpf_cnpj_format_exception"

module CpfCnpjTools
  ##
  # Class responsible for generating and
  # validating CPF and CNPJ numbers
  class Generator
    BLACKLIST_CPF = %w[
      00000000000 11111111111 22222222222 33333333333 44444444444
      55555555555 66666666666 77777777777 88888888888 99999999999
    ].freeze

    REGEX_CPF_FORMATTED = /^\d{3}\.\d{3}\.\d{3}-\d{2}$/.freeze
    REGEX_CNPJ_FORMATTED = %r{^[A-Za-z0-9]{2}\.[A-Za-z0-9]{3}\.[A-Za-z0-9]{3}/[A-Za-z0-9]{4}-\d{2}$}.freeze
    REGEX_CNPJ_UNFORMATTED = /^[A-Z0-9]{12}\d{2}$/.freeze

    CPF1DIGIT = [10, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    CPF2DIGIT = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    CNPJ1DIGIT = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    CNPJ2DIGIT = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze

    ##
    # Method for generating valid CPF numbers
    # @param {Boolean} formatted
    # @return String
    def generate_cpf(formatted: true)
      # Destructure the two arrays returned by the new generate_base
      base_chars, base_values = generate_base(cnpj: false)

      # Calculate the verification digits using base_values
      first_digit = generate_identifier(base_values, true)
      second_digit = generate_identifier(base_values + [first_digit], false)

      # Combine the characters with the calculated digits
      result = (base_chars + [first_digit, second_digit]).join
      return result unless formatted

      format(result)
    end

    ##
    # Method for generating valid CNPJ numbers (Numeric)
    # Standard numeric CNPJs remain 100% valid under the new rules.
    # @param {Boolean} formatted
    # @return String
    def generate_cnpj(formatted: true, alphanumeric: false)
      base_chars, base_values = generate_base(cnpj: true, alphanumeric: alphanumeric)

      first_digit = generate_identifier(base_values, true, cpf: false)
      second_digit = generate_identifier(base_values + [first_digit], false, cpf: false)

      result = (base_chars + [first_digit, second_digit]).join
      return result unless formatted

      format(result)
    end

    ##
    # Method for validating CPF numbers.
    # @param {String, Integer} cpf
    # @return bool
    def cpf_valid?(cpf)
      unformatted = remove_formatting(cpf.to_s)
      return false if BLACKLIST_CPF.include?(unformatted)

      cpf_array = remove_formatting(cpf.to_s).split("").map!(&:to_i)
      return false if cpf_array.length != 11

      first_digit = cpf_array[-2]
      second_digit = cpf_array[-1]
      base_cpf = cpf_array[0..8]
      calculated_first_digit = generate_identifier(base_cpf, true)
      calculated_second_digit = generate_identifier(base_cpf << calculated_first_digit, false)

      return false if (first_digit != calculated_first_digit) || (second_digit != calculated_second_digit)

      true
    end

    ##
    # Method for validating CNPJ numbers (Handles Alphanumeric).
    # @param {Integer, String} cnpj
    # @return bool
    def cnpj_valid?(cnpj)
      unformatted = remove_formatting(cnpj.to_s).upcase

      return false unless unformatted.match?(REGEX_CNPJ_UNFORMATTED)

      cnpj_array = unformatted.chars
      first_digit = cnpj_array[-2].to_i
      second_digit = cnpj_array[-1].to_i

      base_cnpj_values = cnpj_array[0..11].map { |char| cnpj_char_to_value(char) }

      calculated_first_digit = generate_identifier(base_cnpj_values, true, cpf: false)
      calculated_second_digit = generate_identifier(base_cnpj_values + [calculated_first_digit], false, cpf: false)

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
      return true if number =~ REGEX_CPF_FORMATTED
      return true if number =~ REGEX_CNPJ_FORMATTED

      false
    end

    ##
    # Returns an unformatted CPF or CNPJ.
    # @param {String, Integer} cpf_or_cnpj
    # @return String
    def remove_formatting(cpf_or_cnpj)
      unformatted = cpf_or_cnpj.to_s.delete("./-")
      return unformatted unless unformatted.empty?

      cpf_or_cnpj.to_s
    end

    ##
    # Returns a String containing a formatted CPF/CNPJ.
    # @param {String, Integer} cpf_or_cnpj
    # @return String
    def format(cpf_or_cnpj)
      if cpf_valid?(cpf_or_cnpj)
        cpf = remove_formatting(cpf_or_cnpj).dup
        cpf.insert(3, ".")
           .insert(7, ".")
           .insert(-3, "-")
      elsif cnpj_valid?(cpf_or_cnpj)
        cnpj = remove_formatting(cpf_or_cnpj).upcase.dup
        cnpj.insert(2, ".")
            .insert(6, ".")
            .insert(10, "/")
            .insert(-3, "-")
      else
        raise InvalidCpfCnpjFormatError
      end
    end

    ##
    # Returns an array of valid random generated CPF numbers
    # @param {Integer} number
    # @param {bool} formatted
    # @return {Array[String]}
    def generate_array_of_cpf(number, formatted: true)
      array = []
      number.times do
        array << generate_cpf(formatted: formatted)
      end
      array
    end

    ##
    # Returns an array of valid random generated CNPJ numbers
    # @param {Integer} number
    # @param {bool} formatted
    # @return {Array[String]}
    def generate_array_of_cnpj(number, formatted: true, alphanumeric: false)
      array = []
      number.times do
        array << generate_cnpj(formatted: formatted, alphanumeric: alphanumeric)
      end
      array
    end

    private

    ##
    # Converts a character to its mathematical value for CNPJ calculation.
    # Numbers retain face value. Letters use ASCII value - 48.
    # @param char (String)
    # @return Integer
    def cnpj_char_to_value(char)
      char.match?(/[A-Z]/) ? char.ord - 48 : char.to_i
    end

    ##
    # Generate the first numbers of CPF/CNPJ
    # randomly.
    # @param cnpj (Boolean)
    # @return (Array)
    def generate_base(cnpj: false, alphanumeric: false)
      pool = ("0".."9").to_a
      pool += ("A".."Z").to_a if alphanumeric

      base_chars = []

      if cnpj
        8.times { base_chars << pool.sample }
        4.times { base_chars << pool.sample }
      else
        9.times { base_chars << rand(10).to_s }
      end

      base_values = base_chars.map do |char|
        char.match?(/[A-Z]/) ? char.ord - 48 : char.to_i
      end

      [base_chars, base_values]
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
