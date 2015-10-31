require_relative './input_parser.rb'

class DateCityManager

  def initialize(input_parser)
    @input_parser = input_parser
  end

  def get_info(filename)
    info_dict = @input_parser.get_info(filename)
    info_dict.each do |key, value|
      instance_variable_set("@#{key}", value)
      self.class.send(:define_method, key, -> { instance_variable_get("@#{key}") })
    end
  end
end
# 
# parser = InputParser.new
# manager = DateCityManager.new(parser)
# manager.get_info('input_test.csv')
