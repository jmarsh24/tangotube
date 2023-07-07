module ExternalVideoImport
  module MetadataProcessing
    class SongInWrittenFormConverter
      def search_title(title)
        convert_numbers_to_spanish(title)
      end

      private

      def convert_numbers_to_spanish(text)
        number_mapping = {
          "1" => "uno",
          "2" => "dos",
          "3" => "tres",
          "4" => "cuatro",
          "5" => "cinco",
          "6" => "seis",
          "7" => "siete",
          "8" => "ocho",
          "9" => "nueve",
          "10" => "diez",
          "11" => "once",
          "12" => "doce",
          "13" => "trece",
          "14" => "catorce",
          "15" => "quince",
          "16" => "dieciséis",
          "17" => "diecisiete",
          "18" => "dieciocho",
          "19" => "diecinueve",
          "20" => "veinte",
          "30" => "treinta",
          "40" => "cuarenta",
          "50" => "cincuenta",
          "60" => "sesenta",
          "70" => "setenta",
          "80" => "ochenta",
          "90" => "noventa",
          "100" => "cien"
        }

        converted_text = convert_numbers(text, number_mapping)
        normalized_text = normalize_text(converted_text)

        normalized_text.encode("UTF-8", invalid: :replace, undef: :replace)
      end

      def normalize_text(text)
        text.parameterize(separator: " ")
      end

      def convert_numbers(text, number_mapping)
        text.gsub(/\b\d+\b/) do |number|
          if number.to_i <= 100
            if number.to_i <= 20 || number.to_i % 10 == 0
              number_mapping[number].to_s || number
            else
              tens = (number.to_i / 10) * 10
              units = number.to_i % 10

              if units == 0
                number_mapping[tens.to_s].to_s
              else
                "#{number_mapping[tens.to_s]} y #{number_mapping[units.to_s]}"
              end
            end
          else
            number
          end
        end
      end
    end
  end
end
