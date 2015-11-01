require_relative "./attributes_parser.rb"

class ScrappableObject

  def self.scrappable_attributes
    @scrappable_attributes ||= AttributesParser.new.get_info(@filename)
  end

  def self.finalize!
    scrappable_attributes.each do |scrappable_attribute|
      # Define setter
      define_method("#{scrappable_attribute.attribute}=") do |value|
        attributes[scrappable_attribute.attribute] = value
      end
      # Define getter
      define_method("#{scrappable_attribute.attribute}") do
        attributes[scrappable_attribute.attribute]
      end
      # Define getter from html doc
      define_method("get_#{scrappable_attribute.attribute}") do |doc|
        node_element = doc.send("at_css", scrappable_attribute.selector)
        if node_element.nil?
          attr_value = false
        else
          attr_value = node_element.send(*scrappable_attribute.nokogiri_method_array).strip
        end
        attributes[scrappable_attribute.attribute] = attr_value
      end
    end
    # Define method to get all attributes from html doc
    define_method("get_details") do |doc|
      self.class.scrappable_attributes.each do |scrappable_attribute|
        send("get_#{scrappable_attribute.attribute}", doc)
      end
    end
  end

  def self.filename=(filename)
    @filename = filename
  end

  def initialize(doc)
    get_details(doc)
  end

  def attributes_list
    attributes.keys
  end

  def attributes_values
    attributes.values
  end

  private

  def attributes
    @attributes ||= {}
  end

end
