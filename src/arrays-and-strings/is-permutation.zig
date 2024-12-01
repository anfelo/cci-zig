const std = @import("std");
const expect = std.testing.expect;

pub fn isPermutationArray(str1: []const u8, str2: []const u8) bool {
    var chars_count = [_]i8{0} ** 128;

    for (str1) |char| {
        chars_count[char] += 1;
    }

    return for (str2) |char| {
        chars_count[char] -= 1;

        if (chars_count[char] < 0) {
            return false;
        }
    } else true;
}

pub fn isPermutationSorting(str1: []const u8, str2: []const u8) !bool {
    const allocator = std.heap.page_allocator;

    const cp1 = try allocator.dupe(u8, str1);
    defer allocator.free(cp1);

    const cp2 = try allocator.dupe(u8, str2);
    defer allocator.free(cp2);

    std.mem.sort(u8, cp1, {}, comptime std.sort.asc(u8));
    std.mem.sort(u8, cp2, {}, comptime std.sort.asc(u8));

    return std.mem.eql(u8, cp1, cp2);
}

pub fn isPermutationMaps(str1: []const u8, str2: []const u8) !bool {
    if (str1.len != str2.len) return false;

    var map1 = std.AutoHashMap(u8, u32).init(
        std.testing.allocator,
    );
    defer map1.deinit();

    var map2 = std.AutoHashMap(u8, u32).init(
        std.testing.allocator,
    );
    defer map2.deinit();

    for (str1) |char| {
        const value = map1.get(char) orelse 0;
        try map1.put(char, value + 1);
    }

    for (str2) |char| {
        const value = map2.get(char) orelse 0;
        try map2.put(char, value + 1);
    }

    var iterator = map1.iterator();

    return while (iterator.next()) |entry| {
        const value2 = map2.get(entry.key_ptr.*) orelse break false;
        if (value2 != entry.value_ptr.*) {
            break false;
        }
    } else true;
}

test "is permutation" {
    try expect(isPermutationArray("andres", "serdna"));
    try expect(!isPermutationArray("foo", "bar"));
    try expect(isPermutationArray("error", "rorre"));

    var result = try isPermutationSorting("andres", "serdna");
    try expect(result);
    result = try isPermutationSorting("foo", "bar");
    try expect(!result);
    result = try isPermutationSorting("error", "rorre");
    try expect(result);

    result = try isPermutationMaps("andres", "serdna");
    try expect(result);
    result = try isPermutationMaps("foo", "bar");
    try expect(!result);
    result = try isPermutationMaps("error", "rorre");
    try expect(result);
}
