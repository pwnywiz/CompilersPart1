import java_cup.runtime.*;

%%
/* ----------------- Options and Declarations Section----------------- */

/*
   The name of the class JFlex will create will be Scanner.
   Will write the code to the file Scanner.java.
*/
%class Scanner

/*
  The current line number can be accessed with the variable yyline
  and the current column number with the variable yycolumn.
*/
%line
%column

/*
   Will switch to a CUP compatibility mode to interface with a CUP
   generated parser.
*/
%cup
%unicode

/*
  Declarations

  Code between %{ and %}, both of which must be at the beginning of a
  line, will be copied letter to letter into the lexer class source.
  Here you declare member variables and functions that are used inside
  scanner actions.
*/

%{
    /**
        The following two methods create java_cup.runtime.Symbol objects
    **/
    private Symbol symbol(int type) {
       return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
    StringBuffer stringBuffer = new StringBuffer();
%}

/*
  Macro Declarations

  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.
*/

/* A line terminator is a \r (carriage return), \n (line feed), or
   \r\n. */
LineTerminator = \r|\n|\r\n

/* White space is a line terminator, space, tab, or line feed. */
WhiteSpace     = {LineTerminator} | [ \t\f]

/* A literal integer is is a number beginning with a number between
   one and nine followed by zero or more numbers between zero and nine
   or just a zero.  */

dec_str_lit = [_A-Za-z][_A-Za-z0-9]*

%state STRING

%%
/* ------------------------Lexical Rules Section---------------------- */

<YYINITIAL> {

/* operators */
 "+"      { return symbol(sym.PLUS);   }
 "("      { return symbol(sym.LPAREN); }
 ")"      { return symbol(sym.RPAREN); }
 "="      { return symbol(sym.EQUAL);  }
 ","      { return symbol(sym.COMMA);  }
 "}"      { return symbol(sym.RBRACE); }
 // "{"      { return symbol(sym.LBRACE); }
 ")" + {WhiteSpace} + "{" { return symbol(sym.RPLBRACE); }
 "if"     { return symbol(sym.IF);     }
 "else"   { return symbol(sym.ELSE);   }
 "in"   { return symbol(sym.IN);   }
 \"       { stringBuffer.setLength(0); yybegin(STRING); }
}

<STRING> {
      \"                             { yybegin(YYINITIAL);
                                       return symbol(sym.STRING_LITERAL, stringBuffer.toString()); }
      [^\n\r\"\\]+                   { stringBuffer.append( yytext() ); }
      \\t                            { stringBuffer.append('\t'); }
      \\n                            { stringBuffer.append('\n'); }

      \\r                            { stringBuffer.append('\r'); }
      \\\"                           { stringBuffer.append('\"'); }
      \\                             { stringBuffer.append('\\'); }
}

{dec_str_lit} { return symbol(sym.STR, new String(yytext())); }

{WhiteSpace} { /* just skip what was found, do nothing */ }

/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }
