class Car

  def self.create(car_attributes)
    car = self.new
    car_attributes.each do |key, value|
      car.instance_variable_set("@#{key}", value)
      define_method(key) { instance_variable_get("@#{key}") }
    end
    car
  end
end
