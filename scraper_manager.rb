require "pry"
require "capybara"
require 'capybara/poltergeist'
require_relative "./extensions/nokogiri_extension.rb"
require_relative "./managers/date_city_manager.rb"
require_relative "./managers/car_manager.rb"
require_relative "./scrapers/atrapalo_scraper.rb"
require_relative "./parsers/output_parser.rb"

class ScraperManager

  def initialize(date_city_manager:, filename:, scraper_klass:,
                 car_manager_klass:, output_manager:)
    @date_city_manager = date_city_manager
    date_city_manager.get_info(filename)
    @scraper_klass = scraper_klass
    @car_manager_klass = car_manager_klass
    @output_manager = output_manager
    @car_managers = []
  end

  def start_scrapping
    Capybara.default_max_wait_time = 30

    # session = if ARGV[0] != 'phantomjs'
    session = Capybara::Session.new(:selenium)
    # else
    #   session = Capybara::Session.new(:poltergeist)
    # end
    @date_city_manager.each do |city, date_pair|
      scraper = @scraper_klass.new(session)
      car_manager = @car_manager_klass.new(city: city, dates: date_pair)
      scraper.scrape(car_manager)
      @car_managers << car_manager
    end
    cars = compact_car_managers(@car_managers)
    @output_manager.print_results(cars)
  end

  def compact_car_managers(car_managers)
    cars = []
    car_managers.each do |car_manager|
      car_manager.cars.each do |car|
        car.add_city_date({
          city: car_manager.city,
          start_date: car_manager.start_date,
          end_date: car_manager.end_date
        })
        cars << car
      end
    end

    cars
  end
end


parser = InputParser.new
dates_manager = DateCityManager.new(parser)

manager = ScraperManager.new({
  date_city_manager: dates_manager,
  filename: "inputs/atrapalo/input_test.csv",
  scraper_klass: AtrapaloScraper,
  car_manager_klass: CarManager,
  output_manager: OutputParser.new
})

manager.start_scrapping
