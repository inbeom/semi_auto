module SemiAuto
  module Util
    def self.convert_to_native_types(response)
      if response.is_a?(String) || !(response.respond_to?(:to_h) || response.respond_to?(:to_a))
        result = response
      elsif response.respond_to?(:to_h)
        result = {}

        response.to_h.each do |key, value|
          result[key] = convert_to_native_types(value)
        end
      elsif response.respond_to?(:to_a)
        result = []

        response.to_a.each do |entry|
          result << convert_to_native_types(entry)
        end
      end

      result
    end
  end
end
