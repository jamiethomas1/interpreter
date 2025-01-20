const expect = @import("std").testing.expect;
const expectEqualDeep = @import("std").testing.expectEqualDeep;
const Token = @import("token/token.zig").Token;
const Lexer = @import("lexer/lexer.zig").Lexer;

test "test next token" {
    const input = "=+(){},;";

    const tokens = [_]Token{
        .ASSIGN,
        .PLUS,
        .LPAREN,
        .RPAREN,
        .LBRACE,
        .RBRACE,
        .COMMA,
        .SEMICOLON,
        .EOF,
    };

    var lexer = Lexer.new(input);

    for (tokens) |token| {
        const tok = lexer.nextToken();
        try expectEqualDeep(token, tok);
    }
}

test "full lexer test" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\
        \\let add = fn(x, y) {
        \\  x + y;
        \\};
        \\
        \\let result = add(five, ten);
        \\!-/*5;
        \\5 < 10 > 5;
        \\
        \\if (5 < 10) {
        \\  return true;
        \\} else {
        \\  return false;
        \\}
    ;

    const tokens = [_]Token{
        .LET,
        .{ .IDENT = "five" },
        .ASSIGN,
        .{ .INT = "5" },
        .SEMICOLON,
        .LET,
        .{ .IDENT = "ten" },
        .ASSIGN,
        .{ .INT = "10" },
        .SEMICOLON,
        .LET,
        .{ .IDENT = "add" },
        .ASSIGN,
        .FUNCTION,
        .LPAREN,
        .{ .IDENT = "x" },
        .COMMA,
        .{ .IDENT = "y" },
        .RPAREN,
        .LBRACE,
        .{ .IDENT = "x" },
        .PLUS,
        .{ .IDENT = "y" },
        .SEMICOLON,
        .RBRACE,
        .SEMICOLON,
        .LET,
        .{ .IDENT = "result" },
        .ASSIGN,
        .{ .IDENT = "add" },
        .LPAREN,
        .{ .IDENT = "five" },
        .COMMA,
        .{ .IDENT = "ten" },
        .RPAREN,
        .SEMICOLON,
        .BANG,
        .MINUS,
        .SLASH,
        .ASTERISK,
        .{ .INT = "5" },
        .SEMICOLON,
        .{ .INT = "5" },
        .LT,
        .{ .INT = "10" },
        .GT,
        .{ .INT = "5" },
        .SEMICOLON,
        .IF,
        .LPAREN,
        .{ .INT = "5" },
        .LT,
        .{ .INT = "10" },
        .RPAREN,
        .LBRACE,
        .RETURN,
        .TRUE,
        .SEMICOLON,
        .RBRACE,
        .ELSE,
        .LBRACE,
        .RETURN,
        .FALSE,
        .SEMICOLON,
        .RBRACE,
        .EOF,
    };

    var lexer = Lexer.new(input);

    for (tokens) |token| {
        const tok = lexer.nextToken();
        try expectEqualDeep(token, tok);
    }
}
