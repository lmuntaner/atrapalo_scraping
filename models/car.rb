require_relative "./scrappable_object.rb"
require_relative "./modules/atrapalo_car.rb"

class Car < ScrappableObject
  include AtrapaloCar

  self.filename= "./models/atrapalo_scrappable_attributes.csv"

  self.finalize!
end
