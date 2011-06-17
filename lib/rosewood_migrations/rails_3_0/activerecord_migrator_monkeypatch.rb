module ActiveRecord
  class Migrator
    # The changes here differ from the original rails source code only in
    # swapping the order of the search pattern from <timestamp>_<filename>
    # to <filename>_<timestamp>. The changed lines are annotated with the 
    # comment "#swap pattern order"
    #
    # Wrapping this in a  method_added callback may inspire cries of "WTF?!," 
    # so let me explain that without it, rails seems to load these files 
    # before all of itself, so these changes are overwritten when 
    # rails is fully loaded. 
    
    class_eval do 
      def migrations
        @migrations ||= begin
          files = Dir["#{@migrations_path}/*_[0-9]*.rb"] #swap pattern order

          migrations = files.inject([]) do |klasses, file|
            name, version = file.scan(/([_a-z0-9]*)_([0-9]+).rb/).first #swap pattern order & assigned vars

            raise IllegalMigrationNameError.new(file) unless version
            version = version.to_i

            if klasses.detect { |m| m.version == version }
              raise DuplicateMigrationVersionError.new(version)
            end

            if klasses.detect { |m| m.name == name.camelize }
              raise DuplicateMigrationNameError.new(name.camelize)
            end

            migration = MigrationProxy.new
            migration.name     = name.camelize
            migration.version  = version
            migration.filename = file
            klasses << migration
          end

          migrations = migrations.sort_by { |m| m.version }
          down? ? migrations.reverse : migrations
        end
      end
    end   
  end
end