require 'pry'
require_relative '../models/car.rb'

class CarManager
  attr_reader :cars, :start_date, :end_date, :city

  def initialize(dates:, city:)
    @start_date = dates.first
    @end_date = dates.last
    @city = city
    @cars = []
  end

  def add_car(doc:, params: {})
    @cars << Car.new(doc: doc, params: params)
  end

  def message
    "#{@city}, from: #{@start_date}, until: #{@end_date}"
  end
end
