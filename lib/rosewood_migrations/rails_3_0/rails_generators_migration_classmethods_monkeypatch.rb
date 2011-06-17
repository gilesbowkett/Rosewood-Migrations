module Rails
  module Generators
    module Migration
      module ClassMethods
        # The changes here differ from the original rails source code only in
        # swapping the order of the search pattern from <timestamp>_<filename>
        # to <filename>_<timestamp>. No need to annotate them since the methods 
        # are only 1 line each.
        
        # Wrapping this in a method_added callback may inspire cries 
        # of "WTF?!," so let me explain that without it, rails seems to load these
        # files before all of itself, so these changes are overwritten when 
        # rails is fully loaded. 
        
        def self.method_added(method_name)
          @@monkey_patching ||= false
          
          class_eval do 
            @@monkey_patching = true
            def migration_exists?(dirname, file_name) #:nodoc:
              migration_lookup_at(dirname).grep(/#{file_name}_\d+.rb$/).first
            end
          end if method_name.to_s == "migration_exists?" && !@@monkey_patching
          
          class_eval do 
            @@monkey_patching = true
            def migration_lookup_at(dirname) #:nodoc:
              Dir.glob("#{dirname}/*_[0-9]*.rb")
            end
          end if method_name.to_s == "migration_lookup_at" && !@@monkey_patching
          
          @@monkey_patching = false
        end
      end
    end
  end
end