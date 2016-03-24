import java.io.InputStream;
import java.io.IOException;

class Calc {

    private int lookaheadToken;

    private InputStream in;

    public Calc(InputStream in) throws IOException {
		this.in = in;
		lookaheadToken = in.read();
    }

    private void consume(int symbol) throws IOException, ParseError {
		if (lookaheadToken != symbol)
			throw new ParseError();
		lookaheadToken = in.read();
    }

    private int evalDigit(int digit){
		return digit - '0';
    }

    private int expr() throws IOException, ParseError {
		int term = term();
		int expr2 = expr2(term);
		return expr2;
    }

    private int expr2(int term) throws IOException, ParseError {
	        if (lookaheadToken == '+' || lookaheadToken == '-') {
			char op = (char)lookaheadToken;
			consume(lookaheadToken);
			int nextterm = term();
			if (op == '+') {
				return expr2(term + nextterm);
			}
			else {
					return expr2(term - nextterm);
			}
		}
		return term;
    }

	private int term() throws IOException, ParseError {
		int factor = factor();
		int term2 = term2(factor);
		return term2;
    }

	private int term2(int factor) throws IOException, ParseError {
		if (lookaheadToken == '*' || lookaheadToken == '/') {
			char op = (char)lookaheadToken;
			consume(lookaheadToken);
			int nextfactor = factor();
			if (op == '*') {
				return term2(factor * nextfactor);
			}
			else {
				return term2(factor / nextfactor);
		  }
    }
		return factor;
    }

	private int factor() throws IOException, ParseError {
		if(lookaheadToken >= '0' && lookaheadToken <= '9') {
			int cond = evalDigit(lookaheadToken);
			consume(lookaheadToken);
			return cond;
		}
		else if (lookaheadToken == '(') {
			consume(lookaheadToken);
			int expr = expr();
			if (lookaheadToken == ')') {
				consume(lookaheadToken);
				return expr;
			}
		}
		else {
			throw new ParseError();
		}
    return 0;
    }

    public int eval() throws IOException, ParseError {
		int rv = expr();
		if (lookaheadToken != '\n' && lookaheadToken != -1)
			throw new ParseError();
		return rv;
    }

    public static void main(String[] args) {
		try {
			Calc calc = new Calc(System.in);
			System.out.println(calc.eval());
		}
		catch (IOException e) {
			System.err.println(e.getMessage());
		}
		catch(ParseError err){
			System.err.println(err.getMessage());
		}
    }
}
