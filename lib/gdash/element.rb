class GDash
    class Element
        attr_accessor :properties
        attr_accessor :overrides

        def self.class_for_file(file)
            if file.match(/\.graph/)
                GraphiteGraphElement
            elsif file.match(/\.image/)
                ImageElement
            elsif file.match(/\.html/)
                HtmlElement
            end
        end

        def initialize(file, overrides)
            @properties ||= {
                :title => nil
            }
            @overrides = overrides || {}
            @file = file
            self.instance_eval(File.read(@file)) unless @file == :none
        end

        def method_missing(meth, *args)
            # Handler getter with no args
            if properties.include?(meth) && args.count == 0
              properties[meth]
            elsif overrides.include?(meth) && args.count == 0
              overrides[meth]
            elsif properties.include?(meth)
              properties[meth] = args.first unless @overrides.include?(meth)
            else
              super
            end
        end

        def partial_name
            # Pull out the class name, de-camel-case, and symbolize
            "_#{self.class.to_s.match('.*\:\:(.*)').to_a.last.to_underscore}".to_sym
        end

        def to_html
            # render_erb("#{component.class}.erb")
            "<h2>#{self.class}</h2><p>#{properties.inspect}</p>"
        end
    end
end
