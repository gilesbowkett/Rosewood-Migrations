require 'bundler'
Bundler::GemHelper.install_tasks

# duplicate the existing Rails db:migrate stuff, with just a few key changes. as an aside, I
# wish I had time to refactor this shit, because my God, this is a lot of copy-and-paste for
# the benefit of a very small number of actual changes. specifically, eleven total characters
# in five lines of code.

db_namespace = namespace :db do
  namespace :migrate do
    desc 'Display status of migrations'
    task :status => [:environment, :load_config] do
      config = ActiveRecord::Base.configurations[Rails.env || 'development']
      ActiveRecord::Base.establish_connection(config)
      unless ActiveRecord::Base.connection.table_exists?(ActiveRecord::Migrator.schema_migrations_table_name)
        puts 'Schema migrations table does not exist yet.'
        next  # means "return" for rake task
      end
      db_list = ActiveRecord::Base.connection.select_values("SELECT version FROM #{ActiveRecord::Migrator.schema_migrations_table_name}")
      file_list = []
      Dir.foreach(File.join(Rails.root, 'db', 'migrate')) do |file|
        # first change: the next three lines of actual code represent 60% of all
        # deviations from the original code in this file.
        #
        # old and busted:
        #   only files matching "20091231235959_some_name.rb" pattern
        # new hotness:
        #   only files matching "some_name_20091231235959.rb" pattern
        if match_data = /^(.+)_(\d{14})\.rb$/.match(file)
          status = db_list.delete(match_data[2]) ? 'up' : 'down'
          file_list << [status, match_data[2], match_data[1].humanize]
        end
      end
      db_list.map! do |version|
        ['up', version, '********** NO FILE **********']
      end
      # output
      puts "\ndatabase: #{config['database']}\n\n"
      puts "#{'Status'.center(8)}  #{'Migration ID'.ljust(14)}  Migration Name"
      puts "-" * 50

      # behold, the remaining 40% of all deviations from the original code occur in the
      # next two lines, where we swap migration[2] with migration[1] repeatedly. to be
      # clear, that's measured in lines of code, not characters.
      (db_list + file_list).sort_by {|migration| migration[2]}.each do |migration|
        puts "#{migration[0].center(8)}  #{migration[2].ljust(14)}  #{migration[1]}"
      end
      puts
    end
  end
end

