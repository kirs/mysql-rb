require 'bundler/setup'

def Process.rss() `ps -o rss= -p #{Process.pid}`.chomp.to_i ; end
func = nil
QUERY = "select * from posts limit 100"
if ARGV[0] == 'mysql2'
  puts "benchmarking mysql2"
  require 'mysql2'
  func = ->(i) do
    client = Mysql2::Client.new(host: '127.0.0.1', username: 'root', database: 'sample')
    i.times do
      result = client.query(QUERY, cast: false)
      result.to_a.size
    end
    client.close
  end
else
  puts "benchmarking mysql-rb"
  require 'mysql-rb'
  func = ->(i) do
    client = MysqlRb::Client.new(host: 'localhost', username: 'root', database: 'sample')
    i.times do
      result = client.query(QUERY)
      result.to_a.size
    end
    client.close
  end
end

# require 'stackprof'
# StackProf.run(mode: :object, out: 'tmp/stackprof.dump', interval: 1) do
#   func.call(100)
# end
# exit 1

i = 0
puts "iteration,rss_kb,queries,total_allocated,minor_gc_counts,old_objects,total_freed_objects"
loop do
  i += 1

  50.times do
    func.call(30)
  end
  # puts "iteration ##{i}, RSS: #{Process.rss}kb (made #{50*30} queries)"
  stat = GC.stat
  puts "#{i},#{Process.rss},#{i * (50*30)},#{stat[:total_allocated_objects]},#{stat[:minor_gc_count]},#{stat[:old_objects]},#{stat[:total_freed_objects]}"
end
