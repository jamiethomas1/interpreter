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
