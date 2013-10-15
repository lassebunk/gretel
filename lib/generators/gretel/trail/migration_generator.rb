require 'rails/generators'

module Gretel
  module Trail
    class MigrationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../../templates', __FILE__)
      
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      
      desc "Creates a migration for a table to store trail data"
      def create_migration
        migration_template "trail_migration.rb", "db/migrate/create_gretel_trails.rb"
      end
    end
  end
end