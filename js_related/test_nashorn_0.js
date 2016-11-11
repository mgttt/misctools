//java -jar nashorn1.8.0_112-release-b05.jar test_nashorn_0.js

//SHOULD OK
//NOTES: if not run like this, the next with(java.lang) has problem???
print(java.lang.System.getProperty("java.version"));

//print(print);

//var js_print=print;//KO...
//print(js_print);

//TRY
this.jsprint=print;

with(java.lang){
	System.out.println(this);
	this.jsprint(System.getProperty("java.version"));
	//js_print(System.getProperty("java.version"));//KO
	System.out.println(System.getProperty("java.version"));
}

//print(typeof this);

//for (x in this){
//	print(x);
//}
