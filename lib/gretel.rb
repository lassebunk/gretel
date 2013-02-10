require 'gretel/version'
require 'gretel/crumbs'
require 'gretel/crumb'
require 'gretel/link'
require 'gretel/view_helpers'

ActionView::Base.send :include, Gretel::ViewHelpers