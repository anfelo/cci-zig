const std = @import("std");

pub const isUnique = @import("arrays-and-strings/is-unique.zig");
pub const isPermutation = @import("arrays-and-strings/is-permutation.zig");
pub const urlify = @import("arrays-and-strings/urlify.zig");
pub const palindromePermutation = @import("arrays-and-strings/palindrome-permutation.zig");
pub const oneAway = @import("arrays-and-strings/one-away.zig");
pub const stringCompression = @import("arrays-and-strings/string-compression.zig");

test "cci" {
    std.testing.refAllDecls(@This());
}
