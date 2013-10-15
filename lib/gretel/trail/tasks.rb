require "rake"

module Gretel
  module Trail
    module Tasks
      extend Rake::DSL

      def self.install
        namespace :gretel do
          namespace :trails do
            task :delete_expired => :environment do
              Gretel::Trail.delete_expired
            end
          end
        end
      end
    end
  end
end

Gretel::Trail::Tasks.install