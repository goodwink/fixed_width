class FixedWidth
  class Parser
    def initialize(definition, file)
      @definition = definition
      @file       = file
    end
    
    def parse
      parsed = {}
      groups = @definition.section_groups
      group = groups.shift
      
      read_file.each do |line|
        if group.header.match(line)
          parsed[group.name] ||= {}
          parsed[group.name][group.header.name] ||= []
          parsed[group.name][group.header.name] << group.header.parse(line)
        else
          section = group.sections.find{|s| s.match(line)}
          
          if section
            parsed[group.name][section.name] ||= []
            parsed[group.name][section.name] << section.parse(line)
          else
            group = groups.shift
            redo
          end
        end
      end
    end
          

    private

    def read_file
      #TODO: This will only work if the file has new lines, if the file
      #uses fixed length records without newlines to separate them we
      #need to add some handling for that here reading the line length
      #either from some configuration or via a yield to a block that can
      #read it directly from some header in the file.
      @file.readlines.map(&:chomp)
    end
  end
end