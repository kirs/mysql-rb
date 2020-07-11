require 'byebug'

require_relative './lib/mysql-rb'

client = MysqlRb::Client.new({})
r = client.query("select 1, 2, 3")
puts r.results.inspect

