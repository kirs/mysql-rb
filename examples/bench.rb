require 'bundler/setup'
require 'benchmark/ips'
require 'mysql2'
require 'mysql-rb'

Benchmark.ips do |x|
  x.time = 5
  x.warmup = 2

  x.report("mysql2") do
    client = Mysql2::Client.new(host: '127.0.0.1', username: 'root')
    100.times do
      result = client.query("select now()")
      result.to_a.size
    end
  end

  x.report("mysql-rb") do
    client = MysqlRb::Client.new(host: 'localhost', username: 'root')
    100.times do
      result = client.query("select now()")
      result.to_a.size
    end
  end

  x.compare!
end
