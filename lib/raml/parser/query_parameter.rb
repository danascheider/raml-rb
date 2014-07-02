require 'raml/query_parameter'
require 'raml/parser/node'
require 'raml/errors/unknown_attribute_error'

module Raml
  class Parser
    class QueryParameter < Node

      BASIC_ATTRIBUTES = ATTRIBUTES = %w[description type example]

      attr_accessor :query_parameter

      def parse(name, data)
        @query_parameter = Raml::QueryParameter.new(name)
        data = prepare_attributes(data)
        set_trait_names(data)
        apply_parents_traits
        parse_attributes(data)
        query_parameter
      end

      private

        def parse_attributes(data)
          data.each do |key, value|
            key = underscore(key)
            case key
            when *BASIC_ATTRIBUTES
              query_parameter.send("#{key}=".to_sym, parse_value(value))
            when 'is'
              apply_traits(parse_value(value))
            else
              raise UnknownAttributeError.new "Unknown query paramter key: #{key}"
            end
          end if data
        end

    end
  end
end
