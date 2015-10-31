require 'pry'
require_relative './car.rb'

class CarManager
  attr_reader :cars, :start_date, :end_date, :city

  def initialize(dates:, city:)
    @start_date = dates.first
    @end_date = dates.last
    @city = city
    @cars = []
  end

  def add_car(car_info)
    @cars << Car.create(car_info)
  end
end
#
# manager = CarManager.new(dates: [Date.today, Date.new(2015,11,2)], city: 'Barcelona')
# car_info = {
#   color: 'blue',
#   model: 'Ford'
# }
# manager.add_car(car_info)
# binding.pry
# manager.add_car(car_info)
