//java -jar rhino-1.7.7.1.jar ???.js

//OK
//print(java.lang.System.getProperty("java.version"));

//print(print);

//var js_print=print;//KO...
//print(js_print);

//TRY
this.jsprint=print;

with(java.lang){
	//System.out.println(this.jsprint);
	this.jsprint(System.getProperty("java.version"));
	//js_print(System.getProperty("java.version"));//KO
	System.out.println(System.getProperty("java.version"));
}

//print(typeof this);

//for (x in this){
//	print(x);
//}
