# frozen_string_literal: true

namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user, port, password|
      cmd = "PGPASSWORD=#{password} pg_dump --host #{host} --port #{port} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, host, db, user, port, password|
      cmd = "PGPASSWORD=#{password} pg_restore --verbose --host #{host} --port #{port} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class.module_parent_name.underscore,
          ActiveRecord::Base.connection_db_config.host,
          ActiveRecord::Base.connection_db_config.database,
          ActiveRecord::Base.connection_db_config.configuration_hash[:username],
          ActiveRecord::Base.connection_db_config.configuration_hash[:port]
  end
end
