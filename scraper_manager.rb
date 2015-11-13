require "pry"
require "capybara"
require 'capybara/poltergeist'
require_relative "./extensions/nokogiri_extension.rb"
require_relative "./managers/car_manager.rb"
require_relative "./scrapers/atrapalo_scraper.rb"

class ScraperManager

  def initialize(date_city_manager:, filename:, scraper_klass:,
                 car_manager_klass:, output_manager:, driver: :selenium)
    @date_city_manager = date_city_manager
    @date_city_manager.get_info(filename)
    @scraper_klass = scraper_klass
    @car_manager_klass = car_manager_klass
    @output_manager = output_manager
    @car_managers = []
    @driver = driver
  end

  def start_scrapping
    @start_time = DateTime.now
    Capybara.default_max_wait_time = 30
    session = Capybara::Session.new(@driver)

    @date_city_manager.each do |city, date_pair|
      scraper = @scraper_klass.new(session)
      car_manager = @car_manager_klass.new(city: city, dates: date_pair)
      scraper.scrape(car_manager)
      @car_managers << car_manager
    end
    cars = compact_car_managers(@car_managers)
    @output_manager.print_results(cars)
    print_duration_info
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

  def print_duration_info
    puts "Scraped ended!"
    puts "Started at #{@start_time.strftime('%b %e, %l:%M %p')}"
    puts "Ended at #{DateTime.now.strftime('%b %e, %l:%M %p')}"
  end
end
