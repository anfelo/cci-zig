const std = @import("std");
const expect = std.testing.expect;

pub fn isUnique(str: []const u8) bool {
    return blk: for (0..str.len) |i| {
        for (0..str.len) |j| {
            if (i != j and str[i] == str[j]) {
                break :blk false;
            }
        }
    } else true;
}

pub fn isUniqueMap(str: []const u8) bool {
    var map = std.AutoHashMap(u8, u32).init(
        std.testing.allocator,
    );
    defer map.deinit();

    return for (str) |char| {
        const value = map.get(char) orelse 0;
        if (value > 0) {
            break false;
        }
        map.put(char, 1) catch break false;
    } else true;
}

pub fn isUniqueArray(str: []const u8) bool {
    var char_set = [_]bool{false} ** 128;
    return for (str) |char| {
        if (char_set[char]) {
            break false;
        }
        char_set[char] = true;
    } else true;
}

pub fn isUniqueBitVector(str: []const u8) bool {
    var bit_vector: u32 = 0;
    return for (str) |char| {
        const val: u8 = char - 'a';
        const mask: u32 = @as(u32, 1) <<| val;
        if ((bit_vector & mask) > 0) {
            return false;
        }
        bit_vector |= mask;
    } else true;
}

test "is unique" {
    try expect(isUnique("foo") == false);
    try expect(isUnique("andres") == true);
    try expect(isUnique("other") == true);
    try expect(isUnique("test") == false);

    try expect(isUniqueMap("foo") == false);
    try expect(isUniqueMap("andres") == true);
    try expect(isUniqueMap("other") == true);
    try expect(isUniqueMap("test") == false);

    try expect(isUniqueArray("foo") == false);
    try expect(isUniqueArray("andres") == true);
    try expect(isUniqueArray("other") == true);
    try expect(isUniqueArray("test") == false);

    try expect(isUniqueBitVector("foo") == false);
    try expect(isUniqueBitVector("andres") == true);
    try expect(isUniqueBitVector("other") == true);
    try expect(isUniqueBitVector("test") == false);
    try expect(isUniqueBitVector("zoo") == false);
}
