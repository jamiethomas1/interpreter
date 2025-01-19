const std = @import("std");

pub const Token = union(enum) {
    ILLEGAL,
    EOF,

    // Identifiers + literals
    IDENT: []const u8,
    INT: []const u8,

    // Operators
    ASSIGN,
    PLUS,
    BANG,
    MINUS,
    SLASH,
    ASTERISK,
    LT,
    GT,

    // Delimiters
    COMMA,
    SEMICOLON,

    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,

    // Keywords
    FUNCTION,
    LET,

    pub fn keyword(ident: []const u8) ?Token {
        const map = std.StaticStringMap(Token).initComptime(&.{
            .{ "let", .LET },
            .{ "fn", .FUNCTION },
        });
        return map.get(ident);
    }
};
