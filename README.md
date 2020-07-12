# mysql-rb

Native MySQL client in Ruby.

## Why

* No dependencies like libmysqlclient or mariadb-connector required
* Written in Ruby and easy to contribute to
* Works on any Ruby interpreter (yes, JRuby and no JDBC/ActiveRecord issues)
* Ready for async support

### TODO

* ~Connect and handshake~
* ~Execute queries~
* ~Parse resultsets~
* ~query escape~
* SSL support
* Support for `CLIENT_SESSION_TRACK`

### Design choices

This library does not attempt to capture complete support of MySQL protocol, but it aims to do enough to cover what modern applications and modern MySQL server (5.7+) needs

Here are some of the choices that were deliberately made:

* `UTF8MB4_GENERAL_CI` is the only allowed charset
* `CLIENT_DEPRECATE_EOF` flag is always set

Contributions to support a wider protocol are welcome.

