require 'nokogiri'

class Nokogiri::XML::Element

  def present?
    true
  end

  def parent_content
    parent.content
  end

  def first_content
    first.content
  end

  def second_child_content
    children[2].content
  end

  def third_child_content
    children[3].content
  end
end
