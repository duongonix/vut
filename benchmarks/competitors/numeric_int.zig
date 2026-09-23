const std = @import("std");

pub fn main() !void {
    var total: i64 = 0;
    var i: i64 = 0;
    while (i < 100000) : (i += 1) {
        total += i;
    }
    try std.io.getStdOut().writer().print("{d}\n", .{total});
}
