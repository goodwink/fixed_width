class FixedWidth
  class Definition
    attr_reader :section_groups, :templates, :options

    def initialize(options={})
      @groups  = []
      @templates = {}
      @options   = { :align => :right }.merge(options)
    end
    
    def section_group(name, options={}, &block)
      raise DuplicateSectionNameError.new("Duplicate section group name: '#{name}'") if @groups.detect{|s| s.name == name }

      group = FixedWidth::SectionGroup.new(name, @options.merge(options))
      group.group = self
      yield(group)
      @groups << group
      group
    end

    def template(name, options={}, &block)
      section = FixedWidth::Section.new(name, @options.merge(options))
      yield(section)
      @templates[name] = section
    end

    def method_missing(method, *args, &block)
      section_group(method, *args, &block)
    end
  end
end