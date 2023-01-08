web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e production
release: bundle exec rake db:migrate_if_tables
