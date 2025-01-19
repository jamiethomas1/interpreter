const Token = @import("../token/token.zig").Token;

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
        self.position = self.readPosition;
        self.readPosition += 1;
    }

    pub fn nextToken(self: *Lexer) Token {
        const token: Token = switch (self.ch) {
            '=' => .ASSIGN,
            ';' => .SEMICOLON,
            '(' => .LPAREN,
            ')' => .RPAREN,
            ',' => .COMMA,
            '+' => .PLUS,
            '{' => .LBRACE,
            '}' => .RBRACE,
            else => .EOF,
        };

        self.readChar();
        return token;
    }
};
