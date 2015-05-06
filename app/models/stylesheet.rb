class Stylesheet
  def initialize(options)
    @file_path = options[:file_path]
    @css = options[:css]
  end

  def parse
    documentation = []

    styleguide_comments.each do |comment|
      comment = comment[1]

      name = find_name_for(comment)
      section = find_section_for(comment)
      description = find_description_for(comment)
      example = find_example_for(comment)
      statuses = find_statuses_for(comment)
      template = find_template_for(comment)
      style = find_style_for(comment)

      if name.present? || section.present? || description.present? || example.present? || statuses.present? ||template.present? ||style.present?
        component = Component.new

        component.source = @file_path

        component.name = name if name
        if section
          component.section = section
        else
          component.section = name
        end

        component.description = description if description
        component.example = example if example
        component.statuses = statuses if statuses
        component.template = template if template
        component.style = style if style

        documentation << component
      end
    end
    group_by_section(documentation)
  end

  private

  def group_by_section documentation
    documentation.sort_by(&:section).group_by(&:section).each do |key, group|
      group.sort!{|a,b| a.name.downcase <=> b.name.downcase }
    end
  end

  def find_name_for comment
    regex = /\[Name\](.*?)(\[Section\]|\[Description\]|\[Example\]|\[Statuses\]|\[Template\]|\[Style\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def find_section_for comment
    regex = /\[Section\](.*?)(\[Name\]|\[Description\]|\[Example\]|\[Statuses\]|\[Template\]|\[Style\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def find_description_for comment
    regex = /\[Description\](.*?)(\[Name\]|\[Section\]|\[Example\]|\[Statuses\]|\[Template\]|\[Style\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def find_example_for comment
    regex = /\[Example\](.*?)(\[Name\]|\[Section\]|\[Description\]|\[Statuses\]|\[Template\]|\[Style\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def find_statuses_for comment
    regex = /\[Statuses\](.*?)(\[Name\]|\[Section\]|\[Description\]|\[Example\]|\[Template\]|\[Style\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def find_template_for comment
    regex = /\[Template\](.*?)(\[Name\]|\[Section\]|\[Description\]|\[Example\]|\[Statuses\]|\[Style\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def find_style_for comment
    regex = /\[Style\](.*?)(\[Name\]|\[Section\]|\[Description\]|\[Example\]|\[Statuses\]|\[Template\]|\*\/|\z)/m
    result = scan_comment(comment, regex)
    if result.present?
      result.first[1].strip
    end
  end

  def styleguide_comments
    regex = /\/\*\*(.*?)\*\*\//m
    scan_comment(@css, regex)
  end

  def scan_comment text, regex
    text.to_enum(:scan, regex).map { Regexp.last_match }
  end
end
