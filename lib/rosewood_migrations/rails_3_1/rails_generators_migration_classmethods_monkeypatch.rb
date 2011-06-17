module Rails
  module Generators
    module Migration
      module ClassMethods
        # The changes here differ from the original rails source code only in
        # swapping the order of the search pattern from <timestamp>_<filename>
        # to <filename>_<timestamp>. No need to annotate them since the methods 
        # are only 1 line each.
        def migration_exists?(dirname, file_name) #:nodoc:
          migration_lookup_at(dirname).grep(/#{file_name}_\d+.rb$/).first 
        end
        def migration_lookup_at(dirname) #:nodoc:
          Dir.glob("#{dirname}/*_[0-9]*.rb")
        end
      end
    end
  end
end