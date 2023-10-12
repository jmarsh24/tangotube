web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start
release: bundle exec rake db:migrate_if_tables
