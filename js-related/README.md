# quick notes
```
rhino is default js engine for <j8
nashorn is default js engine for j8+
```

# quick test
list engines w+ rhino
```
$ javac ScriptingForJavaScript.java && java -cp "rhino-1.7.7.1.jar:rhino-js-engine-1.7.7.1.jar:." ScriptingForJavaScript
[rhino-nonjdk, js, rhino, JavaScript, javascript, ECMAScript, ecmascript]
[1]ECMAScript: 1.7
hello from [rhino-nonjdk, js, rhino, JavaScript, javascript, ECMAScript, ecmascript]
[ejs, EmbeddedJavaScript, embeddedjavascript]
[2]EmbeddedECMAScript: 1.7
[nashorn, Nashorn, js, JS, JavaScript, javascript, ECMAScript, ecmascript]
[3]ECMAScript: ECMA - 262 Edition 5.1
hello from [nashorn, Nashorn, js, JS, JavaScript, javascript, ECMAScript, ecmascript]

```
list engines w- rhino
```
$ javac ScriptingForJavaScript.java && java ScriptingForJavaScript
[nashorn, Nashorn, js, JS, JavaScript, javascript, ECMAScript, ecmascript]
[1]ECMAScript: ECMA - 262 Edition 5.1
hello from [nashorn, Nashorn, js, JS, JavaScript, javascript, ECMAScript, ecmascript]
```

is it ok to run in j8- with nashorn?
```
$ javac ScriptingForJavaScript.java && java -cp "nashorn1.8.0_112-release-b05.jar:." ScriptingForJavaScript
```
