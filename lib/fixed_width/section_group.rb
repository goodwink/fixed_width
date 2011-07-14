class FixedWidth
  class SectionGroup
    attr_reader :name, :sections, :options
    attr_writer :header

    def initialize(name, options={})
      @name = name
      @sections  = []
      @options = options
    end
    
    def section(name, options={}, &block)
      raise DuplicateSectionNameError.new("Duplicate section name: '#{name}'") if @sections.detect{|s| s.name == name }

      section = FixedWidth::Section.new(name, @options.merge(options))
      section.section_group = self
      yield(section)
      @sections << section
      section
    end

    def method_missing(method, *args, &block)
      section(method, *args, &block)
    end
  end
end