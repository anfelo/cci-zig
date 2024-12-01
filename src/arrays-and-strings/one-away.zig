const std = @import("std");
const expect = std.testing.expect;

pub fn oneEditAway(str1: []const u8, str2: []const u8) bool {
    const len1: i32 = @intCast(str1.len);
    const len2: i32 = @intCast(str2.len);
    if (@abs(len1 - len2) > 1) {
        return false;
    }

    var char_count = [_]u8{0} ** 128;
    for (str1) |char| {
        const idx = char - 'a';
        char_count[idx] += 1;
    }

    var max_edits = if (str1.len > str2.len) str1.len else str2.len;
    for (str2) |char| {
        const idx = char - 'a';
        if (char_count[idx] > 0) {
            max_edits -= 1;
            char_count[idx] -= 1;
        }
    }

    return max_edits <= 1;
}

pub fn oneEditAwayOneLoop(str1: []const u8, str2: []const u8) bool {
    const len1: i32 = @intCast(str1.len);
    const len2: i32 = @intCast(str2.len);
    if (@abs(len1 - len2) > 1) {
        return false;
    }

    const s1 = if (len1 < len2) str1 else str2;
    const s2 = if (len1 < len2) str2 else str1;

    var idx1: usize = 0;
    var idx2: usize = 0;
    var foundDifference = false;
    while (idx2 < s2.len and idx1 < s1.len) {
        if (s1[idx1] != s2[idx2]) {
            if (foundDifference) {
                return false;
            }
            foundDifference = true;

            if (s1.len == s2.len) {
                idx1 += 1;
            }
        } else {
            idx1 += 1;
        }
        idx2 += 1;
    }
    return true;
}

test "one away" {
    try expect(oneEditAway("pale", "pal"));
    try expect(oneEditAway("pale", "pals"));
    try expect(!oneEditAway("pale", "bae"));
    try expect(!oneEditAway("pale", "palan"));
    try expect(!oneEditAway("pale", "aaaa"));
    try expect(!oneEditAway("pale", "otherlong"));

    try expect(oneEditAwayOneLoop("pale", "pal"));
    try expect(oneEditAwayOneLoop("pale", "pals"));
    try expect(!oneEditAwayOneLoop("pale", "bae"));
    try expect(!oneEditAwayOneLoop("pale", "palan"));
    try expect(!oneEditAwayOneLoop("pale", "aaaa"));
    try expect(!oneEditAwayOneLoop("pale", "otherlong"));
}
