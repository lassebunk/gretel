require 'gretel/version'
require 'gretel/crumb'
require 'gretel/crumbs'
require 'gretel/helper_methods'
require 'gretel/view_link'
require 'gretel/link'
require 'gretel/parent'

ActionView::Base.send :include, Gretel::HelperMethods