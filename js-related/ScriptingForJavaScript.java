import javax.script.ScriptEngineManager;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptEngine;
import javax.script.ScriptException;
import java.util.List;

public class ScriptingForJavaScript {
	public static void main(String[] args) throws Exception {
		try {
			ScriptEngineManager manager = new ScriptEngineManager();
			List<ScriptEngineFactory> factories = manager.getEngineFactories();

			int i=1;
			for (ScriptEngineFactory _factory: factories) {

				String language = _factory.getLanguageName();
				String version = _factory.getLanguageVersion();
				ScriptEngine engine = _factory.getScriptEngine();
				//List names = _factory.getNames();
				//System.out.println(names);
				String name_s = _factory.getNames().toString();
				System.out.println("["+i+"] "+ language + ": " + version);
				System.out.println(name_s);

				//try{
				engine.eval("print('hello from " + name_s + "');");//strange bug for \" ??
				//com.sun.phobos.script.util.ExtendedScriptException: org.mozilla.javascript.EvaluatorException: missing ) after argument list (<Unknown source>#1) in <Unknown source> at line number 1
				//engine.eval("print('Hello, JavaScript!');");
				//} catch (Throwable ex) {
				//	ex.printStackTrace();
				//}
				i++;
			}

			//ScriptEngineManager factory = new ScriptEngineManager();
			////ScriptEngine jsengine= factory.getEngineByName("js");
			//ScriptEngine jsengine= factory.getEngineByName("rhino");

			//jsengine.eval("print(\"Hello, JavaScript!\")");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
