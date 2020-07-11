require 'byebug'

require './lib'

client = Client.new({})
r = client.query("select 1, 2, 3")
puts r.results.inspect

