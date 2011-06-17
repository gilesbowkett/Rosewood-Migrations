if Rails::VERSION::STRING.to_f < 3.1
  require File.dirname(__FILE__) + '/rosewood_migrations/rails_3_0/rails_generators_migration_monkeypatch'
  require File.dirname(__FILE__) + '/rosewood_migrations/rails_3_0/activerecord_migrator_monkeypatch'
  require File.dirname(__FILE__) + '/rosewood_migrations/rails_3_0/rails_generators_migration_classmethods_monkeypatch'
else
  require File.dirname(__FILE__) + '/rosewood_migrations/rails_3_1/rails_generators_migration_monkeypatch'
  require File.dirname(__FILE__) + '/rosewood_migrations/rails_3_1/activerecord_migrator_monkeypatch'
  require File.dirname(__FILE__) + '/rosewood_migrations/rails_3_1/rails_generators_migration_classmethods_monkeypatch'
end
