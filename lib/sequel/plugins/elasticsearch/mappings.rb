module Sequel
  module Plugins
    module Elasticsearch
      # Utility to create Elasticsearch mappings from DB schemas
      class Mappings
        class << self
          def from_column(name, detail)
            {
              type: type(detail)
            }.merge additional(detail)
          end

          private
          def type(detail)
            check = detail[:type]
            check = :text if detail[:db_type] == 'text'
            types[check]
          end

          def additional(detail)
            result = {}
            result[:format] = :epoch_second if detail[:db_type] == 'timestamp'
            result
          end

          def types
            @types ||= begin
              t = Hash.new(:text)
              t[:text] = :text
              t[:string] = :keyword
              t[:integer] = :integer
              t[:datetime] = :date
              t[:timestamp] = :date
              t
            end
          end
        end
      end
    end
  end
end