#lang racket

;CARLOS JIMENEZ 30920188 LENGUAJES DE PROGRAMACION

; Función para convertir un número romano a un número arábigo
(define (romano-a-arabico romano)
  ; Definir las letras romanas y sus valores correspondientes
  (define letras-romanas (string->list "IVXLCDM"))
  (define valores '(1 5 10 50 100 500 1000))
  
  ; Función auxiliar para obtener el valor de una letra romana
  (define (valor letra)
    (list-ref valores (index-of letras-romanas letra)))
  
  ; Función auxiliar para procesar cada letra del número romano
  (define (procesar romano total valor-anterior)
    ; Si ya se han procesado todas las letras, devolver el total
    (if (null? romano)
        total
        ; Si no, obtener el valor de la letra actual
        (let* ([letra (car romano)]
               [valor-actual (valor letra)])
          ; Si el valor actual es mayor o igual que el valor anterior, sumarlo al total
          ; Si el valor actual es menor que el valor anterior, restarlo del total
          (if (>= valor-actual valor-anterior)
              (procesar (cdr romano) (+ total valor-actual) valor-actual)
              (procesar (cdr romano) (- total valor-actual) valor-actual)))))
  
  ; Procesar cada letra del número romano de derecha a izquierda
  (procesar (reverse (string->list romano)) 0 0))

; Función para solicitar al usuario que introduzca un número romano
(define (solicitar-romano)
  ; Solicitar al usuario que introduzca un número romano
  (display "Introduzca el numero romano: ")
  (let ([romano (read-line)])
    ; Convertir el número romano a un número arábigo e imprimir el resultado
    (display (romano-a-arabico romano))))

; Solicitar al usuario que introduzca un número romano e imprimir el número arábigo correspondiente
(solicitar-romano)
