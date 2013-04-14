package parser;
import java.io.ByteArrayInputStream;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.tree.CommonTree;
public class Test {
	public static void main(String[] args) throws Exception {
/*
		String str = "select t1.a, t2.b, t3.a,t4.b from test1 as t1,test2 as t2,test1 as t3 ,test2 as t4 " +
					 "where t1.a = t4.b";
		ByteArrayInputStream stream = new ByteArrayInputStream(str.getBytes());
		//Create an input character stream from standard in
		ANTLRInputStream input = new ANTLRInputStream(stream);
		//Create an ExprLexer that feeds from that stream
		FatwormLexer lexer = new FatwormLexer(input);
		// Create a stream of tokens fed by the 
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		// Create a parser that feeds off the token stream
		FatwormParser parser = new FatwormParser(tokens);
		// Begin parsing at rule statement
		FatwormParser.statement_return r = parser.statement();
		// WALK RESULTING TREE
		CommonTree t = (CommonTree)r.getTree(); // get tree from parser
		System.out.println("...byebye...");
*/
	}
}
