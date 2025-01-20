const std = @import("std");
const repl = @import("repl/repl.zig").Repl;

pub fn main() !void {
    std.debug.print("Hello! This is the Monkey programming language!\n", .{});
    std.debug.print("Feel free to type in commands\n", .{});
    try repl.start();
}
