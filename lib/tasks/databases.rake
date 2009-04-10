namespace :db do
  namespace :schema do

    desc "Create a db/schema.rb file that can be portably used against any DB supported by AR"
    task :dump => :environment do
      require 'active_record/schema_dumper'
      File.open(ENV['SCHEMA'] || "db/schema.rb", "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
      Rake::Task["db:schema:clean"].invoke
    end

    desc "Fix the sysdate timestamps from an oracle schema.rb"
    task :clean => :environment do
      File.open(ENV['SCHEMA'] || "db/schema.rb", 'r+') do |f|
        lines = f.readlines
        lines.each do |it|
          it.gsub!(/:default => #<date : 4903089\/2,0,2299161>,/, '')
          it.gsub!(/:default => "EMPTY_BLOB\(\)",/, '')
        end
        f.pos = 0
        f.print lines
        f.truncate(f.pos)
      end
    end

  end
end