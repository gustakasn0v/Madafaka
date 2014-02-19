DIGIT [0-9]
ID [a-z][a-z0-9]*
%%

{DIGIT}+ {printf("Esto es un int");}


{DIGIT}+"."{DIGIT}* {printf("Esto es un float");}


\'.\' {printf("Esto es un char");}


\"(\\\\|\\\"|[^\\\"])*\" {printf("Esto es una cadena");}


"vdafak" {printf("Tipo void");}


"idafak" {printf("Esto es un tipo int");}


"fdafak" {printf("Esto es el tipo float");}


"cdafak" {printf("Esto es el tipo char");}


"sdafak" {printf("Esto es una cadena");}


"tructdafak" {printf("Esto es un struct");}


"niondafak" {printf("Esto es un union");}


\."!"\. {printf("Paso por referencia");}

\n {printf("Esto es un salto de linea");}



%%
     
	 void main(int argc, char **argv)
	 {
		    ++argv, --argc;  /* skip over program name */
			   if ( argc > 0 )
				        yyin = fopen( argv[0], "r" );
						   else
							        yyin = stdin;
									     
										    yylex();
	 }

	 yywrap() { }
