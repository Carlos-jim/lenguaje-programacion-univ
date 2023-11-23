/* 

Estudiante Carlos Jimenez 30920188 - Lenguajes de Programacion

NOTA: SE CAMBIA LA DIRECCION EL TXT AL LLAMADO DE LA FUNCION leerArchivo

<expresion> ::= <termino> ('+' <termino> | '-' <termino>)*
<termino> ::= <factor> ('*' <factor> | '/' <factor>)*
<factor> ::= <numero> | <variable> | '(' <expresion> ')' | <funcion> '(' <expresion> ')' | <numero> <variable>
<numero> ::= <digito>+ | '-' <digito>+
<variable> ::= <letra> (<letra> | <digito>)*
<operador> ::= '+' | '-' | '*' | '/' | '^'
<funcion> ::= 'sin' | 'cos' | 'tan' | 'csc' | 'sec' | 'cot'
<digito> ::= '0'..'9'
<letra> ::= 'a'..'z' | 'A'..'Z'

*/


// Esta función verifica si una expresión algebraica es válida dentro del parentesis
function esExpresionValida(expresion) {
    // Verifica que la expresión no esté vacía
    if (expresion === '') return false;

    // Verifica que la expresión no comience ni termine con un operador
    var primerCaracter = expresion[0];
    var ultimoCaracter = expresion[expresion.length - 1];

    //Si el ultimo o el
    if ('*/^,'.includes(primerCaracter) || '/'.includes(ultimoCaracter) ) return false;

    // Verifica que no haya dos operadores seguidos
    for (var i = 0; i < expresion.length - 1; i++) {
        if ('+-*/^,'.includes(expresion[i]) && '+-*/^,'.includes(expresion[i + 1])) return false;
    }

    // Si todas las verificaciones pasaron, la expresión es válida
    return true;
}

// Esta función tokeniza una cadena y verifica si la sintaxis es correcta
function tokenize(str, lineas) {
    const fs = require('fs');
    let result = []; // Array para almacenar los tokens
    let token = ''; // Variable para construir cada token
    let stack = []; // Pila para rastrear los paréntesis
    let total_error = 0; // Variable para contar los errores
    let lastChar = undefined; // Variable para almacenar el último carácter procesado
    let primercaracter = str.charAt(0); // Variable para almacenar el primer carácter de la cadena
    let expresion = ''; // Variable para almacenar la expresión dentro del paréntesis
    let str1 = str.replace(/\s/g, ''); //Eliminamos los saltos de linea del str
    
    //console.log(str1)
    // Recorremos cada carácter de la cadena
    for (var i = 0; i < str1.length; i++) {
        token=""; //Vaciamos la variable token
        var char = str1[i]; // Carácter actual

        // Si el primer carácter es un operador, incrementamos total_error
        if ('*/)^,=_'.includes(primercaracter)) total_error++;

        // Si el carácter es un operador, un paréntesis o una coma
        if ('*/()^,+-'.includes(char)) {
            // Si el último carácter también fue un operador, incrementamos total_error
            if ('+-*^,_'.includes(lastChar) && char !== '(') total_error++;

            // Si el token actual no está vacío, lo añadimos al resultado y a la expresión si estamos dentro de un paréntesis
            if (token !== '') {
                result.push(token);
               // if (stack.length > 0) expresion += token;
            }

            // Añadimos el operador, paréntesis o coma al resultado
            result.push(char);

            // Limpiamos el token actual
            token = '';

            // Si el carácter es un paréntesis de apertura, lo añadimos a la pila
            if (char === '(') stack.push(char);

            // Si el carácter es un paréntesis de cierre y la pila no está vacía, quitamos el último paréntesis de apertura de la pila y validamos la expresión
            else if (char === ')' && stack.length > 0) {
                stack.pop();
                if (!esExpresionValida(expresion)) total_error++;
                expresion = ''; // Limpiamos la expresión después de validarla
            }

            // Si hay un paréntesis de cierre sin un paréntesis de apertura previo, incrementamos total_error
            else if (char === ')' && stack.length === 0) total_error++;
        }

        // Si el carácter es un espacio y el token actual no está vacío, lo añadimos al resultado y a la expresión si estamos dentro de un paréntesis
        else if (char === ' ' && token !== '') {
            result.push(token);
            if (stack.length > 0) expresion += token;
            token = ''; // Limpiamos el token actual
        }

        // Si el carácter no es un operador, un paréntesis, una coma ni un espacio, lo añadimos al token actual
        else {
            token += char;

            // Si el token es una función trigonométrica o una variable, lo añadimos al resultado y a la expresión si estamos dentro de un paréntesis
            if (['sin', 'cos', 'tan', 'sqrt'].includes(token) || (token.length === 1 && /[a-z]/.test(token))) {
                result.push(token);
               // if (stack.length > 0) expresion += token;
                token = ''; // Limpiamos el token actual
            }

            // Si el token contiene algún carácter no permitido, incrementamos total_error
            else if (/[^a-z0-9.\r\n " " = _ +*\-^,/ ()]/i.test(token))  total_error++;  //token =''; 
        }


        if (stack.length > 0 && char != "(") expresion += char;

        // Actualizamos el último carácter procesado
        lastChar = char;

        // Limpiamos el primer carácter después de procesarlo
        primercaracter = undefined;
    }

    // Si después de recorrer toda la cadena queda algún token sin añadir, lo añadimos al resultado y a la expresión si estamos dentro de un paréntesis
    if (token !== '') {
        result.push(token);
       // if (stack.length > 0) expresion += token;
    }

    // Si después de recorrer toda la cadena quedan paréntesis de apertura en la pila, incrementamos total_error
    if (stack.length > 0) total_error++;

    // Si el último token es un operador, incrementamos total_error
    if ('+-*/^,_'.includes(result[result.length - 1])) total_error++;

    // Obtén la fecha y hora actuales
    let date = new Date();

    // Formatea la fecha y la hora en un string
    let timestamp = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate() + '_' + date.getHours() + '-' + date.getMinutes() + '-' + date.getSeconds();

    // Usa el timestamp para crear un nombre de archivo único
    let filename = 'EVALUACION_' + timestamp + '.txt';

    // Si hay errores, escribimos en un archivo la línea de error y el número de errores
    if (total_error > 0){
        fs.appendFileSync(filename, `LINEA ${lineas}: Error(es) lexicos/de sintaxis: ${total_error}\n`);
    }

    // Si no hay errores, escribimos en un archivo que la sintaxis está correcta
    else{
        fs.appendFileSync(filename, `LINEA ${lineas}: SINTAXIS OK \n`);
    }
}

const fs = require('fs');

//Funcion para leer txt
function leerArchivo(ruta_archivo) {
    
    fs.readFile(ruta_archivo, 'utf8', function(err, data) {
        //Si hay un error, muestra el error en pantalla (error al encontrar el archivo)
        if (err) {
            console.error("Error: Archivo no encontrado, verifique nuevamente"); //Mensaje en consola
            return;
        }
    lineas = 0
        var lines = data.split('\n'); 
        for (var i = 0; i < lines.length; i++) {  //Bucle for para recorrer el txt
            lineas++  //Contador de las lineas del txt
            tokenize(lines[i], lineas); //Llamamos la funcion y le pasamos el total de contador de lineas y el contenido de la linea
        }
    });
}

//Llamamos la funcion leerArchivo y le pasamos en la direccion del archivo de texto
leerArchivo("prueba.txt")
