require 'test_helper'

class IntergrationTest < Minitest::Test
  def test_lorem_ipsum
    client = new_client
    client.query("CREATE DATABASE IF NOT EXISTS lorem_ipsum")
    `mysql -u root -h 127.0.0.1 lorem_ipsum < test/fixtures/lorem_ipsum.sql`

    client = new_client(database: 'lorem_ipsum')
    client.query("select * from posts limit 100")
  end
end

