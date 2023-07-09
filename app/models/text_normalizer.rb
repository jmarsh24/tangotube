# frozen_string_literal: true

class TextNormalizer
  STOP_WORDS = {
    en: /\b(?:a|an|and|are|as|at|be|but|by|for|if|in|into|is|it|no|not|of|on|or|such|that|the|their|then|there|these|they|this|to|was|will|with)\b/i,
    es: /\b(?:un|una|unos|unas|y|o|pero|por|para|como|al|de|del|los|las)\b/i
  }.freeze

  def self.normalize(text)
    return "" if text.nil?

    ascii_text = text.encode("ASCII", invalid: :replace, undef: :replace, replace: "")
    normalized_text = ascii_text.gsub("'", "").gsub("-", "").parameterize(separator: " ").downcase
    STOP_WORDS.each { |_lang, regex| normalized_text.gsub!(regex, "") }
    normalized_text.squeeze(" ").strip
  end
end
