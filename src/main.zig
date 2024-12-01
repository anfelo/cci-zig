const std = @import("std");

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    defer allocator.free();

    const str = "aabcccccaaa";
    const result = try allocator.alloc(u8, str.len);
    @memcpy(result[0..str.len], str);

    const wow = try test2(allocator, result);
    std.debug.print("{s}\n", .{wow});
}

fn test2(allocator: std.mem.Allocator, str: []u8) ![]u8 {
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
        return str;
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
            std.debug.print("{c}{s}\n", .{ str[i], count_str });
            std.debug.print("{s}\n", .{compressed});
            for (count_str) |count_char| {
                compressed[insert_idx] = count_char;
                insert_idx += 1;
            }
            consecutive_count = 0;
        }
    }

    return compressed;
}
