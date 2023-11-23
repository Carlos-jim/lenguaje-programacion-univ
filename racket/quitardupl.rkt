#lang racket

;CARLOS JIMENEZ 30920188 LENGUAJES DE PROGRAMACION

(define (quitar-dupl palabra)
  (list->string (remove-duplicates (string->list palabra))))

; Función para obtener entrada del usuario
(define (obtener-entrada)
  (display "Por favor, ingrese una palabra: ")
  (read-line))


; Prueba la función
(quitar-dupl (obtener-entrada))
