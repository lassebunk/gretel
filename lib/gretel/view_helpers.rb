module Gretel
  module ViewHelpers
    def breadcrumb(*args)
      
    end

    def breadcrumbs(options = {})
      if block_given?
        yield breadcrumb_links
      end
    end

    def breadcrumb_links

    end
  end
end