const std = @import("std");
const expect = std.testing.expect;

pub fn palidromePermutation(str: []const u8) bool {
    var chars_counts = [_]u8{0} ** 128;

    for (str) |char| {
        if (std.ascii.isAlphabetic(char)) {
            const idx = std.ascii.toLower(char);
            chars_counts[idx] += 1;
        }
    }

    var found_odd: bool = false;
    for (chars_counts) |num| {
        if (num > 0) {
            if (num % 2 != 0) {
                // INFO: If we find a 2nd odd count, then is for sure not a
                // palindrome (even or odd)
                if (found_odd) {
                    return false;
                }
                found_odd = true;
            }
        }
    }

    return true;
}

pub fn palindromePermutationCountOdds(str: []const u8) bool {
    var chars_counts = [_]u8{0} ** 128;
    var odds_count: u8 = 0;

    for (str) |char| {
        if (std.ascii.isAlphabetic(char)) {
            const idx = std.ascii.toLower(char);
            chars_counts[idx] += 1;

            if (chars_counts[idx] % 2 != 0) {
                odds_count += 1;
            } else {
                odds_count -= 1;
            }
        }
    }

    return odds_count <= 1;
}

pub fn palindromePermutationBitVector(str: []const u8) bool {
    var bit_vector: u32 = 0;

    for (str) |char| {
        if (std.ascii.isAlphabetic(char)) {
            const idx: u8 = std.ascii.toLower(char) - 97;
            bit_vector ^= @as(u32, 1) <<| idx;
        }
    }

    return (bit_vector & (bit_vector -| @as(u32, 1))) == 0;
}

test "palidrome permutation" {
    try expect(palidromePermutation("Tact coa"));
    try expect(palidromePermutation("Dogma I am god"));
    try expect(palidromePermutation("Anna"));
    try expect(!palidromePermutation("Andres"));

    try expect(palindromePermutationCountOdds("Tact coa"));
    try expect(palindromePermutationCountOdds("Dogma I am god"));
    try expect(palindromePermutationCountOdds("Anna"));
    try expect(!palindromePermutationCountOdds("Andres"));

    try expect(palindromePermutationBitVector("Tact coa"));
    try expect(palindromePermutationBitVector("Dogma I am god"));
    try expect(palindromePermutationBitVector("Anna"));
    try expect(!palindromePermutationBitVector("Andres"));
}
