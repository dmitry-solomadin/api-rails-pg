RSpec.configure do |config|
  config.before(:suite) { DatabaseRewinder.clean_all }
  config.after(:each) { DatabaseRewinder.clean }
end
