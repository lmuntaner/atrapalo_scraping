class ScrappableAttr
  attr_reader :attribute, :selector, :nokogiri_method_array

  def initialize(attribute_name:, selector:, nokogiri_method_array:)
    @attribute = attribute_name
    @selector = selector
    @nokogiri_method_array = nokogiri_method_array
  end
end
