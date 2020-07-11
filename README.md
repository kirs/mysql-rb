# mysql-rb

Native MySQL client in Ruby.

## Why

* No libmysqlclient or mariadb dependencies
* Written in Ruby and easy to contribute to
* Should work on any interpreter (yes, JRuby and no JDBC fuckery with ActiveRecord)
* Ready for async support

Done:

* Connect and handshake
* Execute queries
* Parse resultsets

Todo saturday:

* Simulate mysql2
* escape
