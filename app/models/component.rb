require 'rdiscount'
require 'haml'

class Component
  attr_accessor :name, :section, :description, :example, :statuses, :template, :style, :source

  def display_description
    RDiscount.new(self.description, :smart, :filter_html).to_html.html_safe if self.description
  end

  def display_example( status=nil )
    b = binding
    puts "!"*60
    puts status
    @status = status
    ERB.new(example,0,'', "@status").result(b) if self.example
  end

  def slug
    self.name.downcase.gsub(/[^a-z]+/, '')
  end
end
