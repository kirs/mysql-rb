# frozen-string-literal: true
require 'socket'
require 'logger'

module MysqlRb
  class Client
    DEFAULT_OPTIONS = {
      port: 3306
    }

    def initialize(options)
      @sock = nil
      @connect_options = DEFAULT_OPTIONS.merge(options)
      if @connect_options[:sock]
        raise NotImplementedError, "connecting to unix socket is not supported"
      end
    end

    def connect
      if connected?
        raise AlreadyConnectedError
      end

      @sock = MysqlRb::Socket.new(@connect_options.fetch(:host), @connect_options.fetch(:port))
      @sock.handshake(
        username: @connect_options.fetch(:username),
        password: @connect_options[:password],
        database: @connect_options[:database]
      )
    end

    def connected?
      !!@sock
    end

    def disconnect
      @sock.close
      @sock = nil
    end

    def query(sql)
      connect unless connected?

      @sock.write_packet(@sock.query_command(sql))

      Result.from(@sock.read_packets)
    end

    def ping
      assert_connected
      @sock.ping
    end

    # libmysqlclient is a lot more sophisticated in escaping chars.
    # It requires connection establish to do escaping based
    # on the current encoding.
    # This adapter only supports UTF8MB4_GENERAL_CI
    # which allowed to greatly simplify escaping.
    #
    # Most of the logic is borrowed from functions on libmysqlclient:
    # * mysql_real_escape_string_quote
    # * escape_string_for_mysql
    def escape(string)
      out = +""
      string.chars.each do |char|
        escape = nil
        case char
        when "\0"
          escape = '0'
        when "\n"				# Must be escaped for logs */
          escape= 'n'
        when "\r"
          escape= 'r';
        when "\\"
          escape= '\\';
        when '\''
          escape= '\'';
        when '"'				# Better safe than sorry */
          escape= '"';
        end

        if escape
          out << '\\'
          out << escape
        else
          out << char
        end
      end
      out
    end

    private

    def assert_connected
      unless connected?
        raise "Not connected"
      end
    end
  end
end

