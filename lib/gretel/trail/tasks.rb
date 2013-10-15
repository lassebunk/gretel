require "rake"

Rake::Task.define_task("gretel:trails:delete_expired" => :environment) do
  Gretel::Trail.delete_expired
end