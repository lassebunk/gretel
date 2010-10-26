require 'fileutils'

cp  File.join(File.dirname(__FILE__), "initializers", "breadcrumbs.rb"),
    File.join(Rails.root, "config", "initializers")