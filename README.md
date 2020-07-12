# mysql-rb

Native MySQL client in Ruby.

## Why

* No dependencies like libmysqlclient or mariadb-connector required
* Written in Ruby and easy to contribute to
* Works on any Ruby interpreter (yes, JRuby and no JDBC/ActiveRecord issues)
* Ready for async support

## API

The API tries to be backward compatible with mysql2 as much as possible.

```ruby
client = MysqlRb::Client.new(host: 'localhost', username: 'root')
result = client.query("select now()")
result.to_a.size
# => 1
result.each do |row|
  row
  # => { "now()" => "2020..." }
end

result.each(as: :array) do |row|
  row
  # => ["2020..."]
end
```

### TODO

* ~Connect and handshake~
* ~Execute queries~
* ~Parse resultsets~
* ~query escape~
* SSL support
* Type casting
* Support for `CLIENT_SESSION_TRACK`
* Custom error classes based on error number
* Handling reconnections

### Design choices

This library does not attempt to capture complete support of MySQL protocol, but it aims to do enough to cover what modern applications and modern MySQL server (5.7+) needs

Here are some of the choices that were deliberately made:

* `UTF8MB4_GENERAL_CI` is the only allowed charset
* `CLIENT_DEPRECATE_EOF` flag is always set

Contributions to support a wider protocol are welcome.

### Performance and benchmarking

It's expected for this Ruby driver to be less performant than [mysql2](https://github.com/brianmario/mysql2/) which is a C extension that wraps `libmysqlclient`.

However, with most MySQL queries and network roundtrips taking multiple milliseconds, it's arguable if some extra overhead from the client is tolerable.

To the limited knowledge of the author, it's not completely fair to compare `GC.stat` of a Ruby client to `GC.stat` of a C ext because allocations made in C land would not be counted.

For that reason, the author chose to compare process RSS (Resident set size) rather than Ruby's internal state of memory.

Check `example/bench_mem.rb` for code of the benchmark.

iteration | queries | RSS (kb), mysql-rb | RSS (kb), mysql2
-- | -- | -- | --
1 | 1500 | 25688 | 28136
2 | 3000 | 26368 | 29520
3 | 4500 | 26528 | 30200
4 | 6000 | 27028 | 30200
5 | 7500 | 27188 | 30200
6 | 9000 | 27432 | 30204
7 | 10500 | 27500 | 30204
8 | 12000 | 27524 | 25920
9 | 13500 | 27524 | 22684
10 | 15000 | 27580 | 22788

The difference in RSS is not orders of magnitude different between a Ruby client and the C client.

The decrease in RSS in mysql2 after the 7th iteration can be explain by Ruby's GC kicking in (remember that C ext doesn't cause to many allocations and it would take longer for GC to start collecting objects).
