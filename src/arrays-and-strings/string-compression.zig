const std = @import("std");
const expect = std.testing.expect;

pub fn stringCompression(allocator: std.mem.Allocator, str: []const u8) ![]u8 {
    var buf: [10]u8 = undefined;
    var compression_len: usize = 0;
    var consecutive_count: u32 = 0;
    for (0..str.len) |i| {
        consecutive_count += 1;

        if (i + 1 >= str.len or str[i] != str[i + 1]) {
            const count_str = try std.fmt.bufPrint(&buf, "{}", .{consecutive_count});
            compression_len += 1 + count_str.len;
            consecutive_count = 0;
        }
    }

    if (compression_len >= str.len) {
        const result = try allocator.alloc(u8, str.len);
        @memcpy(result[0..str.len], str);
        return result;
    }

    var compressed = try allocator.alloc(u8, compression_len);
    var insert_idx: usize = 0;
    compression_len = 0;
    consecutive_count = 0;
    for (0..str.len) |i| {
        consecutive_count += 1;

        if (i + 1 >= str.len or str[i] != str[i + 1]) {
            compressed[insert_idx] = str[i];
            insert_idx += 1;
            const count_str = try std.fmt.bufPrint(&buf, "{}", .{consecutive_count});
            for (count_str) |count_char| {
                compressed[insert_idx] = count_char;
                insert_idx += 1;
            }
            consecutive_count = 0;
        }
    }

    return compressed;
}

test "string compression" {
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var out = try stringCompression(allocator, "aabcccccaaa");
    try expect(std.mem.eql(u8, out, "a2b1c5a3"));

    const str2 = "abcdefg";
    out = try stringCompression(allocator, str2);
    try expect(std.mem.eql(u8, out, str2));
    defer allocator.free(out);
}
