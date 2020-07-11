# frozen-string-literal: true
require 'socket'
require 'logger'

module MysqlRb
  class Client
    DEFAULT_OPTIONS = {
      port: 3306
    }

    def initialize(options)
      @connect_options = DEFAULT_OPTIONS.merge(options)
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

    def escape(query)
    end

    private

    def assert_connected
      unless connected?
        raise "Not connected"
      end
    end
  end
end

