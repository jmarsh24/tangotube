module Adapter
  module Persistence
    class ActiveRecord
      def search(type:, **args)
        ar_rows = type.camelize.constantize.where(args)

        ar_rows.collect do |ar_row|
          Struct.new(type: type, **ar_row.attributes)
        end
      end
    end
  end
end
