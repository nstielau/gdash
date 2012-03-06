class GDash
    class GraphiteGraphElement < Element
        def initialize(file, overrides)
            # @file = file
            # @overrides = overrides
            @graph = GraphiteGraph.new(@file, overrides)
            super(file, overrides)
        end

        def method_missing(meth, *args)
            # Handler getter with no args
            if @graph && @graph.properties && @graph.properties.include?(meth)
              @graph.properties[meth] = args.first unless @overrides.include?(meth)
            elsif @graph && @graph.respond_to?(meth)
                @graph.send(meth, *args)
            else
              super
            end
        end

        def to_html
            "<h2>#{self.class}</h2><p>#{@graph[:url]}</p>"
        end
    end
end