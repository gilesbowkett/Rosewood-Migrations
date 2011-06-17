module ActiveRecord
  class Migrator
    # The changes here differ from the original rails source code only in
    # swapping the order of the search pattern from <timestamp>_<filename>
    # to <filename>_<timestamp>. The changed lines are annotated with the 
    # comment "#swap pattern order"
    def self.migrations(paths)
      paths = Array.wrap(paths)
      
      files = Dir[*paths.map { |p| "#{p}/*_[0-9]*.rb" }] #swap pattern order
      
      seen = Hash.new false

      migrations = files.map do |file|
        name, version = file.scan(/([_a-z0-9]*)_([0-9]+).rb/).first #swap pattern order & assigned vars

        raise IllegalMigrationNameError.new(file) unless version
        version = version.to_i
        name = name.camelize

        raise DuplicateMigrationVersionError.new(version) if seen[version]
        raise DuplicateMigrationNameError.new(name) if seen[name]

        seen[version] = seen[name] = true

        MigrationProxy.new(name, version, file)
      end

      migrations.sort_by(&:version)
    end    
  end
end