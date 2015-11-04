class AtrapaloScraper

  def initialize(session)
    @session = session
    @url = "http://www.atrapalo.com/coches"
  end

  def check_alert
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

  def get_car_detail_links
    @session.all("a[title='Reservar']").map { |link| link['href'] }
  end

  def get_car_details(manager:, link:)
    @session.visit link
    return unless check_selector?("h1.floatl", "in da detail page")
    doc = Nokogiri::HTML(@session.html)
    manager.add_car(doc)
  end

  def fill_and_search(start_date:, end_date:, city:)
    @session.fill_in "recogida_coc", :with => city
    @session.execute_script("$('date_recogida_coc').value = '#{start_date.strftime("%d-%m-%Y")}';")
    @session.execute_script("$('date_devolucion_coc').value = '#{end_date.strftime("%d-%m-%Y")}';")
    @session.find("input[data-action='search']").click
  end

  def scrape(manager)
    @session.visit @url
    return unless check_selector?("h1.atrapaloFont", "in da home page")
    fill_and_search({
      start_date: manager.start_date,
      end_date: manager.end_date,
      city: manager.city
    })
    # Accept alert if it pops up when no results
    check_alert
    return unless check_selector?("h1.h1resultados", "in da results page for #{manager.message}")
    links = get_car_detail_links
    links.each do |link|
      get_car_details(link: link, manager: manager)
    end
  end
end
