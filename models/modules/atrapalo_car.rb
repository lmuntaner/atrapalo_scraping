module AtrapaloCar
  def add_city_date(city:, start_date:, end_date:)
    attributes["city"] = city
    attributes["start_date"] = start_date
    attributes["end_date"] = end_date
  end

  def city
    attributes["city"]
  end

  def start_date
    attributes["start_date"]
  end

  def end_date
    attributes["end_date"]
  end
end
