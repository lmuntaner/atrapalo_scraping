class Nokogiri::XML::Element

  def present?
    true
  end

  def parent_content
    parent.content
  end
end
