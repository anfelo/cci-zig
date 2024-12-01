const std = @import("std");
const expect = std.testing.expect;

pub fn urlify(str: []u8) void {
    var buffer = [_]u8{0} ** 100;

    var insIdx: usize = 0;
    for (str) |char| {
        if (char == ' ') {
            @memcpy(buffer[insIdx .. insIdx + 3], "%20");
            insIdx += 3;
        } else {
            buffer[insIdx] = char;
            insIdx += 1;
        }
    }

    @memcpy(str[0..], buffer[0..str.len]);
}

pub fn urlifyNoBuffer(str: []u8, true_len: u8) void {
    var num_spaces: usize = 0;
    for (0..true_len) |i| {
        if (str[i] == ' ') {
            num_spaces += 1;
        }
    }

    var outer_idx: usize = (true_len - 1) + (num_spaces * 2);
    var inner_idx: usize = true_len - 1;

    while (inner_idx > 0) : (inner_idx -= 1) {
        if (str[inner_idx] == ' ') {
            str[outer_idx] = '0';
            str[outer_idx - 1] = '2';
            str[outer_idx - 2] = '%';
            outer_idx -|= 3;
        } else {
            str[outer_idx] = str[inner_idx];
            outer_idx -|= 1;
        }
    }
}

test "urlify" {
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const str = "The great game    ";
    const result = try allocator.alloc(u8, str.len);
    @memcpy(result[0..str.len], str);

    urlify(result);
    try expect(std.mem.eql(u8, result, "The%20great%20game"));

    const str2 = "The great game    ";
    const result2 = try allocator.alloc(u8, str2.len);
    @memcpy(result2[0..str2.len], str2);

    urlifyNoBuffer(result2, 14);
    try expect(std.mem.eql(u8, result2, "The%20great%20game"));
}
