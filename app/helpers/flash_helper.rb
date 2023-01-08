# frozen_string_literal: true

module FlashHelper
  def classes_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      "notice alert-warning"
    else
      "alert alert-info"
    end
  end

  def icons_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      "error"
    else
      "done"
    end
  end
end
