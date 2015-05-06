require 'rdiscount'

class Component
  attr_accessor :name, :section, :description, :example, :statuses, :url, :source

  def display_description
    RDiscount.new(self.description, :smart, :filter_html).to_html.html_safe if self.description
  end

  def display_example_status(status)
    ERB.new(example, status).result if self.example
  end

  def display_example
    ERB.new(example).result if self.example
  end

  def slug
    self.name.downcase.gsub(/[^a-z]+/, '')
  end
end
