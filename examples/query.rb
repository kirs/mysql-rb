require 'bundler/setup'
require 'byebug'

require 'mysql-rb'

client = MysqlRb::Client.new(host: 'localhost', username: 'kirs', password: 'password')
r = client.query("select 1, 2, 3")
r.each do |row|
  puts row.inspect
end

