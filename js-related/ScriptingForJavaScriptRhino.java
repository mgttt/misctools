import javax.script.ScriptEngineManager;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptEngine;
import javax.script.ScriptException;
import java.util.List;
import org.mozillar.javascript.RhinoScriptEngineFactory;

public class ScriptingForJavaScriptRhino {
	public static void main(String[] args) throws Exception {
		try {
			ScriptEngineManager manager = new ScriptEngineManager();
			List<ScriptEngineFactory> factories = manager.getEngineFactories();

			int i=1;
			for (ScriptEngineFactory _factory: factories) {

				String language = _factory.getLanguageName();
				String version = _factory.getLanguageVersion();
				ScriptEngine engine = _factory.getScriptEngine();
				List names = _factory.getNames();
				System.out.println(names);
				System.out.println("["+i+"]"+ language + ": " + version);
				i++;
			}

			ScriptEngineManager factory = new ScriptEngineManager();
			//ScriptEngine jsengine= factory.getEngineByName("js");
			ScriptEngine jsengine= factory.getEngineByName("rhino");
			jsengine.eval("print(\"Hello, JavaScript!\")");
		} catch (ScriptException ex) {
			ex.printStackTrace();
		}
	}
}
