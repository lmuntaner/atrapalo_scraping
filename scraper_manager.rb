require "pry"
require "capybara"
require_relative "./input_parser"
require_relative "./date_city_manager.rb"
require_relative "./car_manager.rb"
require_relative "./atrapalo_scraper.rb"

class ScraperManager

  def initialize(date_city_manager:, filename:, scraper:, car_manager:)
    @date_city_manager = date_city_manager
    date_city_manager.get_info(filename)
    @scraper = scraper
    @car_manager = car_manager
  end

  def start_scrapping
    Capybara.default_max_wait_time = 30

    # session = if ARGV[0] != 'phantomjs'
    session = Capybara::Session.new(:selenium)
    # else
    #   require 'capybara/poltergeist'
    #   session = Capybara::Session.new(:poltergeist)
    # end
    scraper = @scraper.new(session)
    city = @date_city_manager.cities.first
    dates = @date_city_manager.dates.first
    car_manager = @car_manager.new(city: city, dates: dates)
    scraper.scrape(car_manager)
  end
end


parser = InputParser.new
dates_manager = DateCityManager.new(parser)

manager = ScraperManager.new({
  date_city_manager: dates_manager,
  filename: "input_test.csv",
  scraper: AtrapaloScraper,
  car_manager: CarManager
})

manager.start_scrapping
