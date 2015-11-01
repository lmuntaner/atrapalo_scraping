require "pry"
require "csv"
require_relative "./scrappable_attribute.rb"

class AttributesParser

  def get_info(filename)
    scrappable_attributes = []
    header = true
    CSV.foreach(filename) do |row|
      if header
        header = false
      else
        formatted_attribute_name = row.first.downcase.split(" ").join("_")
        nokogiri_method_array = row[2].split(",").map(&:strip)
        scrappable_attributes << ScrappableAttr.new({
          attribute_name: formatted_attribute_name,
          selector: row[1],
          nokogiri_method_array: nokogiri_method_array,
        })
      end
    end
    scrappable_attributes
  end
end
