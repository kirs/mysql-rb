require 'bundler/setup'
require 'minitest/autorun'
require_relative '../lib'

class OmgTest < Minitest::Test
  def test_parse_handshake
    f = "\n8.0.17\x00\"\x00\x00\x00!\x12NW%hq-\x00\xFF\xFF-\x02\x00\xFF\xC3\x15\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00V\aN)#h\x01%S\\q\f\x00caching_sha2_password\x00"
    hs = parse_handshake(StringIO.new(f))
    assert_equal 10, hs.protocol
    assert_equal "8.0.17", hs.version
    assert_equal 34, hs.connid
    assert_equal 65535, hs.cap
    assert_equal 45, hs.encoding
    assert_equal 50175, hs.extcap
  end
end
