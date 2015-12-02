require 'mechanize'

class AtrapaloScraper

  def initialize(session)
    @session = session
    @url = "http://www.atrapalo.com"
    @mechanize = Mechanize.new
  end

  def check_alert
    sleep 20
    @session.driver.browser.switch_to.alert.accept
  rescue Selenium::WebDriver::Error::NoSuchAlertError
    return
  end

  def check_selector?(selector, message)
    if @session.has_css?(selector)
      puts message
      true
    else
      puts ":( no tagline fonud, possibly something's broken"
      false
    end
  end

  def create_attrs(hidden_inputs)
    hidden_inputs.inject({}) do |attrs, hidden_input|
      key = hidden_input.attributes["name"].value
      value = hidden_input.attributes["value"].value
      attrs[key] = value
      attrs
    end
  end

  def get_car_and_post_details
    doc = Nokogiri::HTML(@session.html)
    forms = doc.css('form[action="/coches/carrito_base/"]')
    forms.map do |form|
      hidden_inputs = form.css('[type="hidden"]')
      attrs = create_attrs(hidden_inputs)
      attrs[:payment_method] = form.at_css('.tipo-pago').content
      attrs
    end
  end

  def get_car_details_page(body_params:, url:)
    begin
      # car_detail_page = @mechanize.post(url, body_params)
      @mechanize.post(url, body_params).parser
    rescue Mechanize::ResponseCodeError
      puts 'Status Code Error Fetching Car info'
      return false
    end
    # car_detail_page.save('car_page.html')
    # doc = car_detail_page.parser
    # puts 'creating car...'
    # manager.add_car(doc: doc, params: car_params)
  end

  def fill_and_search(start_date:, end_date:, city:)
    @session.fill_in "recogida_coc", :with => city
    @session.execute_script("$('date_recogida_coc').value = '#{start_date.strftime("%d-%m-%Y")}';")
    @session.execute_script("$('date_devolucion_coc').value = '#{end_date.strftime("%d-%m-%Y")}';")
    @session.find("input[data-action='search']").click
  end

  def scrape(manager)
    @session.visit "#{@url}/coches"
    return unless check_selector?("h1.atrapaloFont", "in da home page")
    fill_and_search({
      start_date: manager.start_date,
      end_date: manager.end_date,
      city: manager.city
    })
    # Accept alert if it pops up when no results
    check_alert
    return unless check_selector?("h1.h1resultados", "in da results page for #{manager.message}")
    search_time = DateTime.now
    car_post_details = get_car_and_post_details
    car_post_details.each do |car_post_attrs|
      sleep 5
      car_params = {
        payment_method: car_post_attrs[:payment_method],
        search_time: search_time.strftime('%b %e, %l:%M %p')
      }
      car_post_attrs.delete(:payment_method)
      car_detail_page = get_car_details_page({
          url: "#{@url}/coches/carrito_base/",
          body_params: car_post_attrs
        })
      return unless car_detail_page
      puts 'creating car...'
      manager.add_car(doc: car_detail_page, params: car_params)
    end
  end
end
