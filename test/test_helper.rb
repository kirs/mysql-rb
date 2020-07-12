require 'bundler/setup'
require 'minitest/autorun'
require 'byebug'
require 'mysql-rb'

class Minitest::Test
  private

  def new_client(opts = {})
    MysqlRb::Client.new({ host: 'localhost', username: 'root' }.merge(opts))
  end
end
