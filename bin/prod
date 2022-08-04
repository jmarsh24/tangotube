export RAILS_ENV=production
bundle install
yarn install
yarn build
yarn build:css
bin/rails assets:precompile
bin/rails server -b 0.0.0.0
