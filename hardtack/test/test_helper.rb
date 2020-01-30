ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require_relative '../lib/encryption'
require_relative '../lib/string_util'
require_relative '../lib/login/hardtack_auth'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login(user)
    hardtack_access_token = Encryption.encrypt(user.id.to_s)
    cache_key = Login::HardtackAuth.cache_key(hardtack_access_token)
    Rails.cache.write(cache_key, user.id)
    "Bearer #{hardtack_access_token}"
  end
end
