# frozen_string_literal: true

# FIXME: this is called an abstract class, it helps you namespace things, like in this case your Ahoy things.
# In the Ahoy classes, simply replace the ApplicationRecord with AhoyRecord and you can remove the `self.table_name = ` line

class AhoyRecord < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = "ahoy_"
end
