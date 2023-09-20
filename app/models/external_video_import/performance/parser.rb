# frozen_string_literal: true

module ExternalVideoImport
  module Performance
    class Parser
      # This regex matches performance numbers separated by a slash (/) or dot (.).
      # Example: Matches "1/ 3" in "Javier Rodriguez & Fatima Vitale 1/ 3 | 15th tango2istanbul"
      PERFORMANCE_REGEX = /(?<=\D|^)(?:\()?(?:(\d+)[.\/]\s?(\d+))(?:\))?(?=\s|$)/

      # This regex matches show numbers in the format "Show.No.#".
      # Example: Matches "4" in "[Milonga] 2023.09.09 - Maja Petrovic & Marko Miljevic - Show.No.4"
      SHOW_NO_REGEX = /Show\.No\.(\d+)/

      # This regex matches performance numbers where the performance is mentioned by itself.
      # Example: Matches "2" in "Agustina Piaggio & Carlitos Espinoza London Scottish House Performance 2"
      PERFORMANCE_ONLY_REGEX = /Performance (\d+)$/

      # This regex matches lone performance numbers separated by a period.
      # Example: Matches "4" in "Carlos Espinoza & Noelia Hurtado. 4. PLANETANGO-XXI Tango Festival"
      PERFORMANCE_LONE_NUMBER_REGEX = /(?<=\.)\s*(?<!\d\.)(\d+)\s*\./

      # This regex matches performance numbers denoted with a hash symbol.
      # Example: Matches "1" in "Milonga TA-TAA! - Taunus, near Frankfurt, Germany (24. 6. 2023) ~ DJ Pepa Palazon #1"
      HASH_POSITION_REGEX = /#(\d+)(?=\s|$)/

      # This regex matches ordinal numbers in video titles.
      # Example: Matches "2" in "Sebastian Bolivar & Cynthia Palacios (29 Jun 2023): 2nd Dance"
      ORDINAL_POSITION_REGEX = /(\d+)(?:st|nd|rd|th)(?=\s|$)/

      # This regex matches performance ranges.
      # It's currently not used, but could match strings like "3-4" in "Performance 3-4".
      RANGE_POSITION_REGEX = /(\d+)-(\d+)(?=\s|$)/

      # This regex matches performance numbers separated by a tilde (~).
      # Example: Matches "2~5" in "Alexa Yepes & Edwin Espinoza l Maipo Juan D' Arienzol Puerto del tango l 2~5"
      PERFORMANCE_TILDE_REGEX = /(?<=\D|^)(?:\()?(?:(\d+)~(\d+))(?:\))?(?=\s|$)/

      # This regex matches performance numbers separated by a single space.
      # Example: Matches "2 4" in "Mariano Otero y Alejandra Mantiñán 16°Tangofestivalvacanze in Puglia 22 07 2022 2 4"
      PERFORMANCE_SPACE_REGEX = /(?<=\D|^)(?:\()?(?:(\d+) (\d+))(?:\))?(?=\s|$)/

      # This regex matches performance numbers that are at the end of a text,
      # may have a leading zero, and are 1 or 2 digits long.
      # Example: Matches "04" in "Noelia Hurtado y Carlitos Espinoza - 04"
      PERFORMANCE_TRAILING_REGEX = /(\b\d{1,2}\b)$/

      # This regex matches performance numbers that are flanked by hyphens after the word "Part".
      # Example: Matches "1" in "Georgia Priskou & Loukas Balokas – El Tigre Millan by Juan D’Arienzo, #sultanstango '22. Part -1-"
      PART_HYPHEN_NUMBER_REGEX = /Part\s?-\s?(\d+)\s?-/

      # Example: Matches "1" in "Performance 1 Rocio Lequío und Bruno Tombari in Bamberg 2023"
      PERFORMANCE_ONLY_REGEX = /Performance (\d+)(?=\s|$)/

      # This regex matches performance numbers in the format "(X de Y)".
      # Example: Matches "3" and "3" in "Carla Rossi y José Luis Salvo - Milonga Gente Amiga - 2022 (3 de 3)"
      PERFORMANCE_DE_REGEX = /\((\d+) de (\d+)\)/

      # This regex matches a lone performance number surrounded by hyphens or spaces.
      # Example: Matches "04" in "Andrés Molina & Natacha Lockwood - 04 - Milonga del 900 @ La Mandrilera"
      PERFORMANCE_HYPHEN_REGEX = /(?<=\s|-)\s*(\d{1,3})\s*(?=-|\s)/

      PERFORMANCE_OF_REGEX = /(?<=\D|^)(?:\()?(?:(\d+) of (\d+))(?:\))?(?=\s|$)/

      Performance = Struct.new(:position, :total, keyword_init: true)

      def parse(text:)
        sanitized_text = sanitize_dates(text)
        patterns = [
          {regex: SHOW_NO_REGEX, total_group: nil},
          {regex: HASH_POSITION_REGEX, total_group: nil},
          {regex: RANGE_POSITION_REGEX, total_group: 2},
          {regex: PERFORMANCE_TILDE_REGEX, total_group: 2},
          {regex: PERFORMANCE_REGEX, total_group: 2},
          {regex: ORDINAL_POSITION_REGEX, total_group: nil},
          {regex: PERFORMANCE_OF_REGEX, total_group: 2},
          {regex: PERFORMANCE_ONLY_REGEX, total_group: nil},
          {regex: PERFORMANCE_LONE_NUMBER_REGEX, total_group: nil},
          {regex: PERFORMANCE_SPACE_REGEX, total_group: 2},
          {regex: PERFORMANCE_TRAILING_REGEX, total_group: nil},
          {regex: PART_HYPHEN_NUMBER_REGEX, total_group: nil},
          {regex: PERFORMANCE_ONLY_REGEX, total_group: nil},
          {regex: PERFORMANCE_DE_REGEX, total_group: 2},
          {regex: PERFORMANCE_HYPHEN_REGEX, total_group: nil}
        ]

        patterns.each do |pattern|
          match = sanitized_text.match(pattern[:regex])

          next unless match

          position = match[1].to_i
          next if position > 8

          total = pattern[:total_group] ? match[pattern[:total_group]].to_i : nil

          return nil if total && (position > total || total == 1)
          return Performance.new(position:, total:)
        end

        nil
      end

      private

      def sanitize_dates(text)
        date_patterns = [
          /\d{4}\.\d{1,2}\.\d{1,2}/,          # YYYY.MM.DD
          /\d{1,2}\.\d{1,2}\.\d{4}/,          # DD.MM.YYYY
          /\d{1,2}\/\d{1,2}\/\d{2,4}/,        # MM/DD/YYYY or MM/DD/YY
          /\d{1,2} \w{3,4} \d{4}/,            # DD Mon YYYY (like 29 Jun 2023)
          /\(\d{1,2}\.\d{1,2}\.\d{4}\)/,      # (DD.MM.YYYY)
          /\(\d{1,2}\.\d{1,2}\.\d{2}\)/,      # (DD.MM.YY)
          /\d{1,2} \d{1,2} \d{4}/             # DD MM YYYY
        ]

        sanitized_text = text.dup

        date_patterns.each do |pattern|
          sanitized_text.gsub!(pattern, "")
        end

        sanitized_text
      end
    end
  end
end
