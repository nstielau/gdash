require 'gdash/element'
require 'gdash/element/graphite_graph_element'
require 'gdash/element/image_element'
require 'gdash/element/html_element'

class GDash
    class Dashboard
        attr_accessor :properties

        def initialize(short_name, dir, overrides={})
            raise "Cannot find dashboard directory #{dir}" unless File.directory?(dir)

            @properties = {}
            @properties[:short_name] = short_name
            @properties[:directory] = File.join(dir, short_name)
            @properties[:yaml] = File.join(dir, short_name, "dash.yaml")
            @properties[:graph_width] ||= 500
            @properties[:graph_height] ||= 250

            raise "Cannot find YAML file #{yaml}" unless File.exist?(yaml)

            @properties.merge!(YAML.load_file(yaml))
            @overrides = {:height => 250, :width => 500}.merge(overrides)
        end

        def elements()
            Dir.entries(directory).sort.map do |element_file|
                if element_class = Element.class_for_file(element_file)
                    element_class.new(File.join(directory, element_file), @overrides)
                end
            end.reject{|x| x.nil? }
        end

        def method_missing(method, *args)
            if properties.include?(method)
                properties[method]
            else
                super
            end
        end
    end
end
