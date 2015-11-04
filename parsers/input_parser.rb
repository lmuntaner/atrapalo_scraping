require 'csv'
require 'pry'

class InputParser

  def initialize
    @info_dict = {}
  end

  def get_info(filename)
    headers = true
    CSV.foreach(filename) do |row|
      if headers
        headers = false
      else
        parse_row(row)
      end
    end
    @info_dict
  end

  def parse_row(row)
    start_date = nil
    row.each_with_index do |input, index|
      next if input.nil?
      if index == 0
        if @info_dict['cities'].nil?
          @info_dict['cities'] = [input]
        else
          @info_dict['cities'] << input
        end
      elsif index == 1
        start_date = Date.parse(input)
      else
        end_date = Date.parse(input)
        dates = [start_date, end_date]
        if @info_dict['dates'].nil?
          @info_dict['dates'] = [dates]
        else
          @info_dict['dates'] << dates
        end
      end
    end
  end
end
