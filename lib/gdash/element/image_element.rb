require 'gdash/element'

class GDash
    class ImageElement < Element
        def initialize(file, overrides)
            @properties = {
                :title => nil,
                :image_url => nil
            }
            super(file, overrides)
        end
    end
end