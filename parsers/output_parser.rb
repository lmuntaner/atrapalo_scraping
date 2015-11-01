class OutputParser

  def print_results(objects)
    CSV.open("results_#{Date.today.to_s}.csv", "wb") do |csv|
      csv << objects.first.attributes_list
      objects.each do |object|
        csv << object.attributes_values
      end
    end
  end
end
