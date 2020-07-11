module MysqlRb
  class Error < StandardError;end
  class ConnectionError < Error;end
  class HandshakeError < ConnectionError;end
  class AlreadyConnectedError < Error;end
end
