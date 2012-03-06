class GDash
    class HtmlElement < Element
        def initialize(file, overrides)
            @properties = {
                :title => nil,
                :image_url => 'asdf',
                :html => ''
            }
            @overrides = overrides || {}
            @file = file
            self.instance_eval(File.read(@file)) unless @file == :none
        end
    end
end