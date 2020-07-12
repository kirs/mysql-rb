require 'test_helper'

module MysqlRb
  class Result
    attr_reader :state # expose into tests
  end
end

class MysqlRb::ResultTest < Minitest::Test
  PACKETS = [1, 0, 0, 1, 3, 23, 0, 0, 2, 3, 100, 101, 102, 0, 0, 0, 1, 49, 0, 12, 63, 0, 1, 0, 0, 0, 8, -127, 0, 0, 0, 0, 23, 0, 0, 3, 3, 100, 101, 102, 0, 0, 0, 1, 50, 0, 12, 63, 0, 1, 0, 0, 0, 8, -127, 0, 0, 0, 0, 23, 0, 0, 4, 3, 100, 101, 102, 0, 0, 0, 1, 51, 0, 12, 63, 0, 1, 0, 0, 0, 8, -127, 0, 0, 0, 0, 6, 0, 0, 5, 1, 49, 1, 50, 1, 51, 7, 0, 0, 6, -2, 0, 0, 2, 0, 0, 0]

  def test_results
    r = build_result

    assert_equal 3, r.fields.size
    r.fields.each_with_index do |f, i|
      assert_equal (i+1).to_s.encode("ASCII-8BIT"), f.name
    end

    assert_equal MysqlRb::Result::WAIT_RESULT_SET_DATA, r.state

    assert_equal 1, r.results.size
    row = r.results.first

    assert_equal ["1", "2", "3"], row.data

    assert_equal MysqlRb::Result::WAIT_RESULT_SET_DONE, r.state
  end

  def test_results_each
    r = build_result

    i = 0
    r.each do |row|
      i += 1
      assert_equal ["1", "2", "3"], row.data
    end
    assert_equal 1, i
  end

  def test_results_enumerable
    r = build_result

    assert_equal 1, r.to_a.size
    row = r.first
    assert_equal ["1", "2", "3"], row.data
  end

  def test_server_flags
    r = build_result
    assert_equal 0x0002, r.server_status
  end

  def test_warnings_count
    r = build_result
    assert_equal 0, r.warning_count
  end

  private

  def build_result
    io = StringIO.new(PACKETS.pack("c*"))
    packets = MysqlRb::PacketReader.new(io).read
    MysqlRb::Result.from(packets)
  end
end
