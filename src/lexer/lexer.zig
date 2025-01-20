const std = @import("std");
const Token = @import("../token/token.zig").Token;

const DEBUG_MODE = false;

pub const Lexer = struct {
    input: []const u8,
    position: usize,
    readPosition: usize,
    ch: u8,

    pub fn new(input: []const u8) Lexer {
        var lexer = Lexer{
            .input = input,
            .position = 0,
            .readPosition = 0,
            .ch = 0,
        };
        lexer.readChar();

        return lexer;
    }

    fn readChar(self: *Lexer) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }

        if (DEBUG_MODE) std.debug.print("reading character {c}\n", .{self.ch});

        self.position = self.readPosition;
        self.readPosition += 1;
    }

    pub fn nextToken(self: *Lexer) Token {
        self.skipWhitespace();
        const token: Token = switch (self.ch) {
            ';' => .SEMICOLON,
            '(' => .LPAREN,
            ')' => .RPAREN,
            ',' => .COMMA,
            '+' => .PLUS,
            '{' => .LBRACE,
            '}' => .RBRACE,
            '-' => .MINUS,
            '/' => .SLASH,
            '*' => .ASTERISK,
            '<' => .LT,
            '>' => .GT,
            '=' => blk: {
                if (self.peekChar() == '=') {
                    self.readChar();
                    break :blk .EQ;
                } else {
                    break :blk .ASSIGN;
                }
            },
            '!' => blk: {
                if (self.peekChar() == '=') {
                    self.readChar();
                    break :blk .NOT_EQ;
                } else {
                    break :blk .BANG;
                }
            },
            'a'...'z', 'A'...'Z', '_' => {
                const text = self.readIdentifier();
                if (Token.keyword(text)) |token| {
                    return token;
                }
                return .{ .IDENT = text };
            },
            '0'...'9' => {
                const number = self.readNumber();
                return .{ .INT = number };
            },
            0 => .EOF,
            else => {
                if (DEBUG_MODE) {
                    std.debug.print("failing on character {c}\n", .{self.ch});
                    std.debug.print("with input {s}\n", .{self.input});
                }
                return .ILLEGAL;
            },
        };

        self.readChar();
        return token;
    }

    fn readIdentifier(self: *Lexer) []const u8 {
        const position = self.position;
        while (isLetter(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    fn readNumber(self: *Lexer) []const u8 {
        const position = self.position;
        while (isDigit(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    fn isLetter(ch: u8) bool {
        return std.ascii.isAlphabetic(ch) or ch == '_';
    }

    fn isDigit(ch: u8) bool {
        return std.ascii.isDigit(ch);
    }

    fn skipWhitespace(self: *Lexer) void {
        while (std.ascii.isWhitespace(self.ch)) self.readChar();
    }

    fn peekChar(self: *Lexer) u8 {
        if (self.readPosition >= self.input.len) {
            return 0;
        } else {
            return self.input[self.readPosition];
        }
    }
};
