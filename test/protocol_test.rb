require 'test_helper'

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
  def test_parse_handshake_error
    f = "\xff\x10\x04\x54\x6f\x6f\x20\x6d\x61\x6e\x79\x20" \
      "\x63\x6f\x6e\x6e\x65\x63\x74\x69\x6f\x6e\x73"

    error = assert_raises(MysqlRb::HandshakeError) do
      MysqlRb::HandshakeUtils.parse_handshake(f)
    end
    assert_equal "Error 1040: Too many connections", error.message
  end

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
    assert_equal 1, r.to_a.size
    assert_equal({"DATABASE()" => "tmp_test"}, r.first)
  end

  def test_query_command
    sock = MysqlRb::Socket.new("localhost", 3306)
    actual = sock.query_command("select 1")
    expected = [0x03, 0x73, 0x65, 0x6c, 0x65, 0x63, 0x74, 0x20, 0x31]
    assert_equal expected, actual.unpack("c*")
  end

  def test_datetime
    client = new_client
    r = client.query("select now()")
    assert_equal :datetime, r.fields.first.type_name

    assert_equal 1, r.to_a.size
    assert_equal 1, r.first.size
    t = r.first.values.first
    assert_match(/(\d){4}-(\d){2}-(\d){2}/, t[0..9])
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
    assert_equal expected, actual
  end

  def test_escape_multibyte
    client = new_client
    actual = client.escape("ø\nø")
    expected = "ø\\nø"
    assert_equal expected, actual
  end
end
