require_relative '../parsers/input_parser.rb'

class DateCityManager
  attr_reader :cities, :dates

  def initialize(input_parser)
    @input_parser = input_parser
  end

  def get_info(filename)
    info_dict = @input_parser.get_info(filename)
    @dates = info_dict["dates"]
    @cities = info_dict["cities"]
  end

  def each &block
    pairs = []
    @cities.each do |city|
      @dates.each do |date_pair|
        pairs << [city, date_pair]
      end
    end
    pairs.each &block
  end
end
