#lang racket

;CARLOS JIMENEZ 30920188 LENGUAJES DE PROGRAMACION

; Función para eliminar vocales de una cadena
(define (quitar-vocales lista)
  (map (lambda (palabra) 
         (list->string 
          (filter (lambda (letra) 
                    (not (member letra '(#\a #\e #\i #\o #\u #\A #\E #\I #\O #\U))))
                  (string->list palabra))))
       lista))

; Función para obtener entrada del usuario
(define (obtener-entrada)
  (display "Por favor, ingrese las palabras separadas por espacios: ")
  (let ((entrada (read-line)))
    (string-split entrada)))

; Prueba la función
(quitar-vocales (obtener-entrada))
