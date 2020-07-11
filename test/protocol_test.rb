require 'bundler/setup'
require 'minitest/autorun'
require 'byebug'
require_relative '../lib/mysql-rb'

SHITTON = [
        0x01, 0x00, 0x00, 0x01, 0x64, 0x17, 0x00, 0x00, 0x02, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x01, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x17, 0x00, 0x00, 0x03, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x01, 0x32,
        0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x17,
        0x00, 0x00, 0x04, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x01, 0x33, 0x00, 0x0c, 0x3f,
        0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x05,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x01, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x06, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x01, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x07, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x01, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x17, 0x00, 0x00, 0x08, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x01, 0x37,
        0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x17,
        0x00, 0x00, 0x09, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x01, 0x38, 0x00, 0x0c, 0x3f,
        0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x0a,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x01, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x01, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x0b, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x02, 0x31, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00,
        0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x0c, 0x03, 0x64, 0x65, 0x66, 0x00,
        0x00, 0x00, 0x02, 0x31, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81,
        0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x0d, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00,
        0x02, 0x31, 0x32, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x18, 0x00, 0x00, 0x0e, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x31,
        0x33, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00,
        0x18, 0x00, 0x00, 0x0f, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x31, 0x34, 0x00,
        0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00,
        0x00, 0x10, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x31, 0x35, 0x00, 0x0c, 0x3f,
        0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x11,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x31, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x02,
        0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x12, 0x03, 0x64,
        0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x31, 0x37, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x13, 0x03, 0x64, 0x65, 0x66,
        0x00, 0x00, 0x00, 0x02, 0x31, 0x38, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x14, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x02, 0x31, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00,
        0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x15, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x32, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00,
        0x00, 0x18, 0x00, 0x00, 0x16, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x32, 0x31,
        0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x17, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x32, 0x32, 0x00, 0x0c,
        0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
        0x18, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x32, 0x33, 0x00, 0x0c, 0x3f, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x19, 0x03,
        0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x32, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x1a, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x02, 0x32, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00,
        0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x1b, 0x03, 0x64, 0x65, 0x66, 0x00,
        0x00, 0x00, 0x02, 0x32, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81,
        0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x1c, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00,
        0x02, 0x32, 0x37, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x18, 0x00, 0x00, 0x1d, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x32,
        0x38, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00,
        0x18, 0x00, 0x00, 0x1e, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x32, 0x39, 0x00,
        0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00,
        0x00, 0x1f, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x30, 0x00, 0x0c, 0x3f,
        0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x20,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x02,
        0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x21, 0x03, 0x64,
        0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x32, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x22, 0x03, 0x64, 0x65, 0x66,
        0x00, 0x00, 0x00, 0x02, 0x33, 0x33, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x23, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x02, 0x33, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00,
        0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x24, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x33, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00,
        0x00, 0x18, 0x00, 0x00, 0x25, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x36,
        0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x26, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x37, 0x00, 0x0c,
        0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
        0x27, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x38, 0x00, 0x0c, 0x3f, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x28, 0x03,
        0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x33, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x29, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x02, 0x34, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00,
        0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x2a, 0x03, 0x64, 0x65, 0x66, 0x00,
        0x00, 0x00, 0x02, 0x34, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81,
        0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x2b, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00,
        0x02, 0x34, 0x32, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x18, 0x00, 0x00, 0x2c, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x34,
        0x33, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00,
        0x18, 0x00, 0x00, 0x2d, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x34, 0x34, 0x00,
        0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00,
        0x00, 0x2e, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x34, 0x35, 0x00, 0x0c, 0x3f,
        0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x2f,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x34, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x02,
        0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x30, 0x03, 0x64,
        0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x34, 0x37, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x31, 0x03, 0x64, 0x65, 0x66,
        0x00, 0x00, 0x00, 0x02, 0x34, 0x38, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x32, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x02, 0x34, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00,
        0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x33, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x35, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00,
        0x00, 0x18, 0x00, 0x00, 0x34, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x35, 0x31,
        0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x35, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x35, 0x32, 0x00, 0x0c,
        0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
        0x36, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x35, 0x33, 0x00, 0x0c, 0x3f, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x37, 0x03,
        0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x35, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x38, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x02, 0x35, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00,
        0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x39, 0x03, 0x64, 0x65, 0x66, 0x00,
        0x00, 0x00, 0x02, 0x35, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81,
        0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x3a, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00,
        0x02, 0x35, 0x37, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x18, 0x00, 0x00, 0x3b, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x35,
        0x38, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00,
        0x18, 0x00, 0x00, 0x3c, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x35, 0x39, 0x00,
        0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00,
        0x00, 0x3d, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x30, 0x00, 0x0c, 0x3f,
        0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x3e,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x02,
        0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x3f, 0x03, 0x64,
        0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x32, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x40, 0x03, 0x64, 0x65, 0x66,
        0x00, 0x00, 0x00, 0x02, 0x36, 0x33, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x41, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x02, 0x36, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00,
        0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x42, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x36, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00,
        0x00, 0x18, 0x00, 0x00, 0x43, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x36,
        0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x44, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x37, 0x00, 0x0c,
        0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
        0x45, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x38, 0x00, 0x0c, 0x3f, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x46, 0x03,
        0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x36, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x47, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x02, 0x37, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00,
        0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x48, 0x03, 0x64, 0x65, 0x66, 0x00,
        0x00, 0x00, 0x02, 0x37, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81,
        0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x49, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00,
        0x02, 0x37, 0x32, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x18, 0x00, 0x00, 0x4a, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x37,
        0x33, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00,
        0x18, 0x00, 0x00, 0x4b, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x37, 0x34, 0x00,
        0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00,
        0x00, 0x4c, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x37, 0x35, 0x00, 0x0c, 0x3f,
        0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x4d,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x37, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x02,
        0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x4e, 0x03, 0x64,
        0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x37, 0x37, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x4f, 0x03, 0x64, 0x65, 0x66,
        0x00, 0x00, 0x00, 0x02, 0x37, 0x38, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x50, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x02, 0x37, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00,
        0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x51, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x38, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00,
        0x00, 0x18, 0x00, 0x00, 0x52, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x38, 0x31,
        0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x53, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x38, 0x32, 0x00, 0x0c,
        0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
        0x54, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x38, 0x33, 0x00, 0x0c, 0x3f, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x55, 0x03,
        0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x38, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x56, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x02, 0x38, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00,
        0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x57, 0x03, 0x64, 0x65, 0x66, 0x00,
        0x00, 0x00, 0x02, 0x38, 0x36, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81,
        0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x58, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00,
        0x02, 0x38, 0x37, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00,
        0x00, 0x00, 0x18, 0x00, 0x00, 0x59, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x38,
        0x38, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00,
        0x18, 0x00, 0x00, 0x5a, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x38, 0x39, 0x00,
        0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00,
        0x00, 0x5b, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x30, 0x00, 0x0c, 0x3f,
        0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x5c,
        0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x31, 0x00, 0x0c, 0x3f, 0x00, 0x02,
        0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x5d, 0x03, 0x64,
        0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x32, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x5e, 0x03, 0x64, 0x65, 0x66,
        0x00, 0x00, 0x00, 0x02, 0x39, 0x33, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08,
        0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x5f, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00,
        0x00, 0x02, 0x39, 0x34, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00,
        0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x60, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x39, 0x35, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00,
        0x00, 0x18, 0x00, 0x00, 0x61, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x36,
        0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18,
        0x00, 0x00, 0x62, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x37, 0x00, 0x0c,
        0x3f, 0x00, 0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
        0x63, 0x03, 0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x38, 0x00, 0x0c, 0x3f, 0x00,
        0x02, 0x00, 0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x64, 0x03,
        0x64, 0x65, 0x66, 0x00, 0x00, 0x00, 0x02, 0x39, 0x39, 0x00, 0x0c, 0x3f, 0x00, 0x02, 0x00,
        0x00, 0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x19, 0x00, 0x00, 0x65, 0x03, 0x64, 0x65,
        0x66, 0x00, 0x00, 0x00, 0x03, 0x31, 0x30, 0x30, 0x00, 0x0c, 0x3f, 0x00, 0x03, 0x00, 0x00,
        0x00, 0x08, 0x81, 0x00, 0x00, 0x00, 0x00, 0x24, 0x01, 0x00, 0x66, 0x01, 0x31, 0x01, 0x32,
        0x01, 0x33, 0x01, 0x34, 0x01, 0x35, 0x01, 0x36, 0x01, 0x37, 0x01, 0x38, 0x01, 0x39, 0x02,
        0x31, 0x30, 0x02, 0x31, 0x31, 0x02, 0x31, 0x32, 0x02, 0x31, 0x33, 0x02, 0x31, 0x34, 0x02,
        0x31, 0x35, 0x02, 0x31, 0x36, 0x02, 0x31, 0x37, 0x02, 0x31, 0x38, 0x02, 0x31, 0x39, 0x02,
        0x32, 0x30, 0x02, 0x32, 0x31, 0x02, 0x32, 0x32, 0x02, 0x32, 0x33, 0x02, 0x32, 0x34, 0x02,
        0x32, 0x35, 0x02, 0x32, 0x36, 0x02, 0x32, 0x37, 0x02, 0x32, 0x38, 0x02, 0x32, 0x39, 0x02,
        0x33, 0x30, 0x02, 0x33, 0x31, 0x02, 0x33, 0x32, 0x02, 0x33, 0x33, 0x02, 0x33, 0x34, 0x02,
        0x33, 0x35, 0x02, 0x33, 0x36, 0x02, 0x33, 0x37, 0x02, 0x33, 0x38, 0x02, 0x33, 0x39, 0x02,
        0x34, 0x30, 0x02, 0x34, 0x31, 0x02, 0x34, 0x32, 0x02, 0x34, 0x33, 0x02, 0x34, 0x34, 0x02,
        0x34, 0x35, 0x02, 0x34, 0x36, 0x02, 0x34, 0x37, 0x02, 0x34, 0x38, 0x02, 0x34, 0x39, 0x02,
        0x35, 0x30, 0x02, 0x35, 0x31, 0x02, 0x35, 0x32, 0x02, 0x35, 0x33, 0x02, 0x35, 0x34, 0x02,
        0x35, 0x35, 0x02, 0x35, 0x36, 0x02, 0x35, 0x37, 0x02, 0x35, 0x38, 0x02, 0x35, 0x39, 0x02,
        0x36, 0x30, 0x02, 0x36, 0x31, 0x02, 0x36, 0x32, 0x02, 0x36, 0x33, 0x02, 0x36, 0x34, 0x02,
        0x36, 0x35, 0x02, 0x36, 0x36, 0x02, 0x36, 0x37, 0x02, 0x36, 0x38, 0x02, 0x36, 0x39, 0x02,
        0x37, 0x30, 0x02, 0x37, 0x31, 0x02, 0x37, 0x32, 0x02, 0x37, 0x33, 0x02, 0x37, 0x34, 0x02,
        0x37, 0x35, 0x02, 0x37, 0x36, 0x02, 0x37, 0x37, 0x02, 0x37, 0x38, 0x02, 0x37, 0x39, 0x02,
        0x38, 0x30, 0x02, 0x38, 0x31, 0x02, 0x38, 0x32, 0x02, 0x38, 0x33, 0x02, 0x38, 0x34, 0x02,
        0x38, 0x35, 0x02, 0x38, 0x36, 0x02, 0x38, 0x37, 0x02, 0x38, 0x38, 0x02, 0x38, 0x39, 0x02,
        0x39, 0x30, 0x02, 0x39, 0x31, 0x02, 0x39, 0x32, 0x02, 0x39, 0x33, 0x02, 0x39, 0x34, 0x02,
        0x39, 0x35, 0x02, 0x39, 0x36, 0x02, 0x39, 0x37, 0x02, 0x39, 0x38, 0x02, 0x39, 0x39, 0x03,
        0x31, 0x30, 0x30, 0x07, 0x00, 0x00, 0x67, 0xfe, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
    ]

class MysqlRb::OmgTest < Minitest::Test
  def test_parse_handshake
    f = "\n8.0.17\x00\"\x00\x00\x00!\x12NW%hq-\x00\xFF\xFF-\x02\x00\xFF\xC3\x15\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00V\aN)#h\x01%S\\q\f\x00caching_sha2_password\x00"
    hs = MysqlRb::HandshakeUtils.parse_handshake(f)
    assert_equal 10, hs.protocol
    assert_equal "8.0.17", hs.version
    assert_equal 34, hs.connid
    # assert_equal 65535, hs.cap
    assert_equal 45, hs.encoding
    # assert_equal 50175, hs.extcap

    assert_equal [33, 18, 78, 87, 37, 104, 113, 45], hs.scramble_1.unpack("c*")
    assert_equal [86, 7, 78, 41, 35, 104, 1, 37, 83, 92, 113, 12], hs.scramble_2.unpack("c*")
  end

  def test_read_packets
    io = StringIO.new(SHITTON.pack("c*"))
    packets = MysqlRb::PacketReader.new(io).read
    assert_equal 103, packets.size
  end

  def test_results_shitton
    client = new_client
    r = client.query("SELECT #{(1.upto(100).to_a.join(', '))}")
    assert_equal 100, r.fields.size
    r.fields.each_with_index do |f, i|
      assert_equal (i+1).to_s.encode("ASCII-8BIT"), f.name
    end
  end

  def test_select_with_database
    client = new_client
    client.query("CREATE DATABASE IF NOT EXISTS tmp_test")
    client.disconnect

    client = new_client(database: 'tmp_test')
    r = client.query("SELECT DATABASE()")
    assert_equal 1, r.results.size
    assert_equal ["tmp_test"], r.results.first.data
  end

  NOT_SHITTON = [1, 0, 0, 1, 3, 23, 0, 0, 2, 3, 100, 101, 102, 0, 0, 0, 1, 49, 0, 12, 63, 0, 1, 0, 0, 0, 8, 129, 0, 0, 0, 0, 23, 0, 0, 3, 3, 100, 101, 102, 0, 0, 0, 1, 50, 0, 12, 63, 0, 1, 0, 0, 0, 8, 129, 0, 0, 0, 0, 23, 0, 0, 4, 3, 100, 101, 102, 0, 0, 0, 1, 51, 0, 12, 63, 0, 1, 0, 0, 0, 8, 129, 0, 0, 0, 0, 6, 0, 0, 5, 1, 49, 1, 50, 1, 51, 7, 0, 0, 6, 254, 0, 0, 2, 0, 0, 0]
  def test_results
    io = StringIO.new(NOT_SHITTON.pack("c*"))
    packets = MysqlRb::PacketReader.new(io).read

    r = MysqlRb::Result.new(packets)
    assert_equal 3, r.fields.size
    r.fields.each_with_index do |f, i|
      assert_equal (i+1).to_s.encode("ASCII-8BIT"), f.name
    end

    assert_equal 1, r.results.size
    row = r.results.first

    assert_equal ["1", "2", "3"], row.data
  end

  def test_query_command
    skip
    actual = new_client.send(:query_command, "select 1")
    expected = [0x03, 0x73, 0x65, 0x6c, 0x65, 0x63, 0x74, 0x20, 0x31]
    assert_equal expected, actual.unpack("c*")
  end

  def test_datetime
    client = new_client
    r = client.query("select now()")
    assert_equal :datetime, r.fields.first.type_name

    assert_equal 1, r.results.size
    assert_equal 1, r.results.first.data.size
    t = r.results.first.data.first
    assert_equal Time.now.strftime("%Y-%m-%d"), t[0..9]
  end

  def test_connection_error
    client = new_client(host: 'localhost', port: 9999)
    assert_raises(MysqlRb::ConnectionError) do
      client.connect
    end
  end

  def test_ping
    client = new_client
    client.connect
    client.ping
  end

  def test_escape
    client = new_client
    actual = client.escape("abc'def\"ghi\0jkl%mno")
    expected = "abc\\'def\\\"ghi\\0jkl%mno"
# case 0:				/* Must be escaped for 'mysql' */
#       escape= '0';
#       break;
#     case '\n':				/* Must be escaped for logs */
#       escape= 'n';
#       break;
#     case '\r':
#       escape= 'r';
#       break;
#     case '\\':
#       escape= '\\';
#       break;
#     case '\'':
#       escape= '\'';
#       break;
#     case '"':				/* Better safe than sorry */
#       escape= '"';
#       break;
#     case '\032':			/* This gives problems on Win32 */
#       escape= 'Z';
#       break;
#     }
  end

  private

  def new_client(opts = {})
    MysqlRb::Client.new({ host: 'localhost', username: 'root' }.merge(opts))
  end
end
