require_relative "./managers/date_city_manager.rb"
require_relative "./parsers/output_parser.rb"
require_relative "./scraper_manager.rb"

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
