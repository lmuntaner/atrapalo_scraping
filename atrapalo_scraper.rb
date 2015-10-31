class AtrapaloScraper

  ATTR_SELECTORS = {
    dealer: "h1.floatl + img",
    make: "h1.floatl",
    category: ".col12.floatr.relative > p:nth-child(3) span.bold",
    perceived_price: "#precio_total_sin_reembolso",
    total_price: "#precio_total_con_reembolso",
    fuel_policy: "img.combustible",
    pick_up_policy: "",
    limit_km: "li.optKm",
    km_fee: "",
    location: "div.address > h3",
    address: "p.address span.address",
    phone: "div.address span.phone",
    distance: "p.address + p",
    seats: "li.optAd",
    luggage: "li.optMal",
    transmission: "li.optTm",
    pick_up_date: "p.optIn span.bold:first-child",
    pick_up_time: "p.optIn span.bold:nth-child(2)",
    return_date: "p.optOut span.bold:first-child",
    return_time: "p.optOut span.bold:nth-child(2)",
    cancelation_policy: "div.box-incluye-coc > ul li:first-child",
    taxes:"div.box-incluye-coc > ul li:nth-child(2)",
    modifications: "div.box-incluye-coc > ul li:nth-child(3)",
    insurance_conditions: "#tabs-5"
  }

  def initialize(session)
    @session = session
    @url = "http://www.atrapalo.com/coches"
  end

  def check_selector(selector)
    if @session.has_css?(selector)
      puts "All shiny, captain!"
    else
      puts ":( no tagline fonud, possibly something's broken"
    end
  end

  def get_car_detail_links
    @session.all("a[title='Reservar']").map { |link| link['href'] }[0..5]
  end

  def get_car_details(manager:, link:)
    @session.visit link
    check_selector("h1.floatl")
    doc = Nokogiri::HTML(@session.html)
    binding.pry
  end

  def fill_and_search(start_date:, end_date:, city:)
    @session.fill_in "recogida_coc", :with => city
    @session.execute_script("$('date_recogida_coc').value = '#{start_date.strftime("%d-%m-%Y")}';")
    @session.execute_script("$('date_devolucion_coc').value = '#{end_date.strftime("%d-%m-%Y")}';")
    @session.find("input[data-action='search']").click
  end

  def scrape(manager)
    @session.visit @url
    check_selector("h1.atrapaloFont")
    fill_and_search({
      start_date: manager.start_date,
      end_date: manager.end_date,
      city: manager.city
    })
    check_selector("h1.h1resultados")
    links = get_car_detail_links
    links.each do |link|
      get_car_details(link: link, manager: manager)
    end
  end


end
