module Rails
  module Generators
    module Migration
      # Creates a migration template at the given destination. The difference
      # to the default template method is that the migration version is appended
      # to the destination file name.
      #
      # The migration version, migration file name, migration class name are
      # available as instance variables in the template to be rendered.
      #
      # This version of the method is monkey-patched to implement two improvements.
      # First, the filename ends in a string of digits representing a timestamp -
      # normally in a Rails migration the filename *begins* with that string. This
      # allows us to use Unix tab-completion. Second, the migration filename is
      # automatically copied into the OS X copy/paste or "clipboard" buffer. This
      # feature is not supported on other operating systems and this gem might not
      # work on other operating systems.
      #
      # ==== Examples
      #
      #   migration_template "migration.rb", "db/migrate/add_foo_to_bar.rb"
      #
      def migration_template(source, destination=nil, config={})
        destination = File.expand_path(destination || source, self.destination_root)

        migration_dir = File.dirname(destination)
        @migration_number     = self.class.next_migration_number(migration_dir)
        @migration_file_name  = File.basename(destination).sub(/\.rb$/, '')
        @migration_class_name = @migration_file_name.camelize

        destination = self.class.migration_exists?(migration_dir, @migration_file_name)

        if !(destination && options[:skip]) && behavior == :invoke
          if destination && options.force?
            remove_file(destination)
          elsif destination
            raise Error, "Another migration is already named #{@migration_file_name}: #{destination}"
          end
          # These next two lines of code represent the sum total of all deviations from the
          # the original code base contained within this particular file.
          destination = File.join(migration_dir, "#{@migration_number}_#{@migration_file_name}.rb")
          system("printf #{destination} | pbcopy")
        end

        template(source, destination, config)
      end
    end
  end
end

