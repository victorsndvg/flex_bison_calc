# Calculadora científica

## Compilacion:

```
$ make clean
$ make
```

## Ejecución

```
$ ./calculadora
```

## Ayuda

```
############################################################
# Float Scientific calculator v0.1
# 	Operators:
# 		Float: +, -, *, /, =
# 		Binary: &, |, ^, <<, >>
# 	Precedence modifiers: () and []
# 	Constants:
# 		pi = 3.1415926535
# 		e  = 2.7182818284
# 	Functions:
# 		acos, asin, atan, cos, cosh, sin, sinh
# 		tanh, exp, log, log10, sqrt, ceil, fabs
# 		floor, atan2, frexp, ldexp, modf, pow, fmod
# 	Commands:
# 		help(): show this help message
# 		clear(): clear the command line
# 		exit(): turn off the scientific calculator
# Note: 
# 	Use ';' at the end of the line to mute the result
# 	Use 'const' in assignement for user defined constants
############################################################
```

## Ejemplos

1. `[(1 + 2 * 3 * sin(pi))/(log(e) + pow(2,2))] + 7`
2. `[(2 << 2)|(1 << 4)] & 0xF`
3. `x = floor(7.123) * 7`
4. `const alpha = pow(x,2)`
5. `exit()`
