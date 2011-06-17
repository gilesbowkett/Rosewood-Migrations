require 'fileutils'
FileUtils.cp(File.join(File.dirname(__FILE__), '/lib/rosewood_migrations/rosewood_migrations.rake'), File.join(File.dirname(__FILE__), '../../../lib/tasks'))
