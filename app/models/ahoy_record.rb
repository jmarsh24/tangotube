# FIXME: this is called an abstract class, it helps you namespace things, like in this case your Ahoy things.
# In the Ahoy classes, simply replace the ApplicationRecord with AhoyRecord and you can remove the `self.table_name = ` line

class AhoyRecord < ActiveRecord::Base
  self.abstract_class = true
end
``
