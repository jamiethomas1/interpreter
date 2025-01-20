const std = @import("std");
const Token = @import("../token/token.zig").Token;
const Lexer = @import("../lexer/lexer.zig").Lexer;

const PROMPT = ">> ";

pub const Repl = struct {
    var reader = std.io.getStdIn().reader();
    var buffer: [1024]u8 = undefined;

    pub fn start() !void {
        while (true) {
            std.debug.print(">> ", .{});
            if (try reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |input| {
                var lexer = Lexer.new(input);
                while (lexer.hasTokens()) {
                    const token = lexer.nextToken();
                    std.debug.print("{}\n", .{token});
                }
            }
        }
    }
};
