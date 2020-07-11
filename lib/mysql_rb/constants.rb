module MysqlRb
  module Constants
    module StatusFlags

      SERVER_STATUS_IN_TRANS             = 0x0001

      # Server in auto_commit mode.
      SERVER_STATUS_AUTOCOMMIT           = 0x0002

      # Multi query - next query exists.
      SERVER_MORE_RESULTS_EXISTS         = 0x0008

      SERVER_STATUS_NO_GOOD_INDEX_USED   = 0x0010

      SERVER_STATUS_NO_INDEX_USED        = 0x0020

      # The server was able to fulfill the clients request and opened a read-only
      # non-scrollable cursor for a query. This flag comes in reply to COM_STMT_EXECUTE
      # and COM_STMT_FETCH commands. Used by Binary Protocol Resultset to signal that
      # COM_STMT_FETCH must be used to fetch the row-data.
      SERVER_STATUS_CURSOR_EXISTS        = 0x0040

      # This flag is sent when a read-only cursor is exhausted, in reply to
      # COM_STMT_FETCH command.
      SERVER_STATUS_LAST_ROW_SENT        = 0x0080

      # A database was dropped.
      SERVER_STATUS_DB_DROPPED           = 0x0100

      SERVER_STATUS_NO_BACKSLASH_ESCAPES = 0x0200

      # Sent to the client if after a prepared statement reprepare we discovered
      # that the new statement returns a different number of result set columns.
      SERVER_STATUS_METADATA_CHANGED     = 0x0400

      SERVER_QUERY_WAS_SLOW              = 0x0800

      # To mark ResultSet containing output parameter values.
      SERVER_PS_OUT_PARAMS               = 0x1000

      # Set at the same time as SERVER_STATUS_IN_TRANS if the started multi-statement
      # transaction is a read-only transaction. Cleared when the transaction commits
      # or aborts. Since this flag is sent to clients in OK and EOF packets, the flag
      # indicates the transaction status at the end of command execution.
      SERVER_STATUS_IN_TRANS_READONLY    = 0x2000

      # This status flag, when on, implies that one of the state information has
      # changed on the server because of the execution of the last statement.
      SERVER_SESSION_STATE_CHANGED       = 0x4000
    end

    module CapabilityFlags
      # Use the improved version of Old Password Authentication. Assumed to be set since 4.1.1.
      CLIENT_LONG_PASSWORD                  = 0x0000_0001

      # Send found rows instead of affected rows in EOF_Packet.
      CLIENT_FOUND_ROWS                     = 0x0000_0002

      # Get all column flags.
      # Longer flags in Protocol::ColumnDefinition320.
      #
      # ### Server
      # Supports longer flags.
      #
      # ### Client
      # Expects longer flags.
      CLIENT_LONG_FLAG                      = 0x0000_0004

      # Database (schema) name can be specified on connect in Handshake Response Packet.
      # ### Server
      # Supports schema-name in Handshake Response Packet.
      #
      # ### Client
      # Handshake Response Packet contains a schema-name.
      CLIENT_CONNECT_WITH_DB                = 0x0000_0008

      # Don't allow database.table.column.
      CLIENT_NO_SCHEMA                      = 0x0000_0010

      # Compression protocol supported.
      #
      # ### Server
      # Supports compression.
      #
      # ### Client
      # Switches to Compression compressed protocol after successful authentication.
      CLIENT_COMPRESS                       = 0x0000_0020

      # Special handling of ODBC behavior.
      CLIENT_ODBC                           = 0x0000_0040

      # Can use LOAD DATA LOCAL.
      #
      # ### Server
      # Enables the LOCAL INFILE request of LOAD DATA|XML.
      #
      # ### Client
      # Will handle LOCAL INFILE request.
      CLIENT_LOCAL_FILES                    = 0x0000_0080

      # Ignore spaces before '('.
      #
      # ### Server
      # Parser can ignore spaces before '('.
      #
      # ### Client
      # Let the parser ignore spaces before '('.
      CLIENT_IGNORE_SPACE                   = 0x0000_0100

      CLIENT_PROTOCOL_41                    = 0x0000_0200

      # This is an interactive client.
      # Use System_variables::net_wait_timeout versus System_variables::net_interactive_timeout.
      #
      # ### Server
      # Supports interactive and noninteractive clients.
      #
      # ### Client
      # Client is interactive.
      CLIENT_INTERACTIVE                    = 0x0000_0400

      # Use SSL encryption for the session.
      #
      # ### Server
      # Supports SSL
      #
      # ### Client
      # Switch to SSL after sending the capability-flags.
      CLIENT_SSL                            = 0x0000_0800

      # Client only flag. Not used.
      #
      # ### Client
      # Do not issue SIGPIPE if network failures occur (libmysqlclient only).
      CLIENT_IGNORE_SIGPIPE                 = 0x0000_1000

      # Client knows about transactions.
      #
      # ### Server
      # Can send status flags in OK_Packet / EOF_Packet.
      #
      # ### Client
      # Expects status flags in OK_Packet / EOF_Packet.
      #
      # ### Note
      # This flag is optional in 3.23, but always set by the server since 4.0.
      CLIENT_TRANSACTIONS                   = 0x0000_2000

      CLIENT_RESERVED                       = 0x0000_4000

      CLIENT_SECURE_CONNECTION              = 0x0000_8000

      # Enable/disable multi-stmt support.
      # Also sets CLIENT_MULTI_RESULTS. Currently not checked anywhere.
      #
      # ### Server
      # Can handle multiple statements per COM_QUERY and COM_STMT_PREPARE.
      #
      # ### Client
      # May send multiple statements per COM_QUERY and COM_STMT_PREPARE.
      CLIENT_MULTI_STATEMENTS               = 0x0001_0000

      # Enable/disable multi-results.
      #
      # ### Server
      # Can send multiple resultsets for COM_QUERY. Error if the server needs to send
      # them and client does not support them.
      #
      # ### Client
      # Can handle multiple resultsets for COM_QUERY.
      #
      # ### Requires
      # `CLIENT_PROTOCOL_41`
      CLIENT_MULTI_RESULTS                  = 0x0002_0000

      # Multi-results and OUT parameters in PS-protocol.
      #
      # ### Server
      # Can send multiple resultsets for COM_STMT_EXECUTE.
      #
      # ### Client
      # Can handle multiple resultsets for COM_STMT_EXECUTE.
      #
      # ### Requires
      # `CLIENT_PROTOCOL_41`
      CLIENT_PS_MULTI_RESULTS               = 0x0004_0000

      # Client supports plugin authentication.
      #
      # ### Server
      # Sends extra data in Initial Handshake Packet and supports the pluggable
      # authentication protocol.
      #
      # ### Client
      # Supports authentication plugins.
      #
      # ### Requires
      # `CLIENT_PROTOCOL_41`
      CLIENT_PLUGIN_AUTH                    = 0x0008_0000

      # Client supports connection attributes.
      #
      # ### Server
      # Permits connection attributes in Protocol::HandshakeResponse41.
      #
      # ### Client
      # Sends connection attributes in Protocol::HandshakeResponse41.
      CLIENT_CONNECT_ATTRS                  = 0x0010_0000

      # Enable authentication response packet to be larger than 255 bytes.
      # When the ability to change default plugin require that the initial password
      # field in the Protocol::HandshakeResponse41 paclet can be of arbitrary size.
      # However, the 4.1 client-server protocol limits the length of the auth-data-field
      # sent from client to server to 255 bytes. The solution is to change the type of
      # the field to a true length encoded string and indicate the protocol change with
      # this client capability flag.
      #
      # ### Server
      # Understands length-encoded integer for auth response data in
      # Protocol::HandshakeResponse41.
      #
      # ### Client
      # Length of auth response data in Protocol::HandshakeResponse41 is a
      # length-encoded integer.
      #
      # ### Note
      # The flag was introduced in 5.6.6, but had the wrong value.
      CLIENT_PLUGIN_AUTH_LENENC_CLIENT_DATA = 0x0020_0000

      # Don't close the connection for a user account with expired password.
      #
      # ### Server
      # Announces support for expired password extension.
      #
      # ### Client
      # Can handle expired passwords.
      CLIENT_CAN_HANDLE_EXPIRED_PASSWORDS   = 0x0040_0000

      # Capable of handling server state change information.
      # Its a hint to the server to include the state change information in OK_Packet.
      #
      # ### Server
      # Can set SERVER_SESSION_STATE_CHANGED in the SERVER_STATUS_flags_enum and send
      # Session State Information in a OK_Packet.
      #
      # ### Client
      # Expects the server to send Session State Information in a OK_Packet.
      CLIENT_SESSION_TRACK                  = 0x0080_0000

      # Client no longer needs EOF_Packet and will use OK_Packet instead.
      #
      # ### Server
      # Can send OK after a Text Resultset.
      #
      # ### Client
      # Expects an OK_Packet (instead of EOF_Packet) after the resultset
      # rows of a Text Resultset.
      #
      # ### Background
      # To support CLIENT_SESSION_TRACK, additional information must be sent after all
      # successful commands. Although the OK_Packet is extensible, the EOF_Packet is
      # not due to the overlap of its bytes with the content of the Text Resultset Row.
      #
      # Therefore, the EOF_Packet in the Text Resultset is replaced with an OK_Packet.
      # EOF_Packet is deprecated as of MySQL 5.7.5.
      CLIENT_DEPRECATE_EOF                  = 0x0100_0000

      # Client or server supports progress reports within error packet.
      CLIENT_PROGRESS_OBSOLETE              = 0x2000_0000

      # Verify server certificate. Client only flag.
      #
      # Deprecated in favor of –ssl-mode.
      CLIENT_SSL_VERIFY_SERVER_CERT         = 0x4000_0000

      # Don't reset the options after an unsuccessful connect. Client only flag.
      CLIENT_REMEMBER_OPTIONS               = 0x8000_0000
    end
  end
end
