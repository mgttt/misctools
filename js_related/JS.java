import java.util.NoSuchElementException;
import java.util.Scanner;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

public class JS {
	public static void main(String[] args) {
		ScriptEngine se = new ScriptEngineManager().getEngineByName("nashorn");
		//ScriptEngine se = new ScriptEngineManager().getEngineByName("rhino");//KO in j8
		Scanner s = new Scanner(System.in);

		String in = "";
		System.out.print("> ");

		while (true){
			try {
				in += s.nextLine(); // get more code
				se.eval(in);		// try eval
			} catch (ScriptException e) {
				if (e.getMessage().contains("but found eof")){ // incomplete expression
					System.out.print("|\t");
				} else {										// JS error
						in = "";
					System.out.print("Error: " + e.getMessage() + "\n> ");
				}
				continue;
			} catch (NoSuchElementException e){ // EOF, no more code
				break;
			}
			// JS expression successfully evaluated
				in = "";
			System.out.print("> ");
		}

		s.close();
	}
}
