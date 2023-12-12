#lang racket
;Carlos Jimenez 30920188 Lenguajes de programacion

; Verifica si un valor puede ser colocado en una posición específica en el tablero
(define (is-valid board row col value N top bottom left right)
  ; Convierte la fila en una lista y obtiene los valores de la columna
  (let* ([row-values (vector->list (list-ref board row))]
         [col-values (map (lambda (r) (vector-ref (list-ref board r) col)) (range N))]
         [in-row? (member value row-values)]
         [in-col? (member value col-values)])
    ; Si el valor ya está en la misma fila o columna, devuelve falso
    (if (or in-row? in-col?)
        #f
        ; Comprueba el número de edificios visibles desde la derecha y desde abajo
        (let* ([right-seen (if (= col (- N 1))
                               (let loop ([i (- N 2)] [max-height value] [seen 1])
                                 (if (< i 0)
                                     seen
                                     (if (> (list-ref row-values i) max-height)
                                         (loop (- i 1) (list-ref row-values i) (+ seen 1))
                                         (loop (- i 1) max-height seen))))
                               0)]
               [bottom-seen (if (= row (- N 1))
                                (let loop ([i (- N 2)] [max-height value] [seen 1])
                                  (if (< i 0)
                                      seen
                                      (if (> (vector-ref (list-ref board i) col) max-height)
                                          (loop (- i 1) (vector-ref (list-ref board i) col) (+ seen 1))
                                          (loop (- i 1) max-height seen))))
                                0)])
          ; Si el número de edificios visibles viola las restricciones, devuelve falso
          (if (or (and (> right-seen 0) (not (= right-seen (list-ref right row))))
                  (and (> bottom-seen 0) (not (= bottom-seen (list-ref bottom col)))))
              #f
              #t)))))

; Resuelve el rompecabezas usando backtracking
(define (solve board row col N top bottom left right)
  ; Si todo el tablero está lleno, imprime la solución
  (if (= row N)
      (begin (display "Solución:\n") (for-each (lambda (r) (display r) (newline)) board))
      ; Si se llega al final de una fila, se pasa a la siguiente fila
      (if (= col N)
          (solve board (+ row 1) 0 N top bottom left right)
          ; Intenta todos los números posibles para la celda actual
          (let loop ([value 1])
            (if (> value N)
                #f
                (if (is-valid board row col value N top bottom left right)
                    (begin
                      ; Si se encuentra un número válido, lo coloca e intenta llenar el resto del tablero
                      (vector-set! (list-ref board row) col value)
                      (if (solve board row (+ col 1) N top bottom left right)
                          #t
                          ; Si el resto del tablero no puede ser llenado, quita el número e intenta el siguiente
                          (begin
                            (vector-set! (list-ref board row) col 0)
                            (loop (+ value 1)))))
                    (loop (+ value 1))))))))

; Punto de entrada del programa
(define (main)
  (display "Introduce las vistas del NORTE, SEPARADA POR ESPACIOS ")
  (let* ([top (map string->number (string-split (read-line)))]
         [N (length top)]) ; Usa la longitud de la lista como el tamaño del tablero
    (if (<= N 10)
        (let* ([board (for/list ([i N]) (make-vector N 0))]) ; Crea el tablero usando una comprensión de lista
          (display "Introduce las vistas del SUR, SEPARADA POR ESPACIOS ")
          (let* ([bottom (map string->number (string-split (read-line)))]
                 [bottom-len (length bottom)])
            (display "Introduce las vistas del OESTE, SEPARADA POR ESPACIOS ")
            (let* ([left (map string->number (string-split (read-line)))]
                   [left-len (length left)])
              (display "Introduce las vistas del ESTE, SEPARADA POR ESPACIOS ")
              (let* ([right (map string->number (string-split (read-line)))]
                     [right-len (length right)])
                ; Si el número de vistas coincide con el tamaño del tablero, resuelve el rompecabezas
                (if (and (= bottom-len N) (= left-len N) (= right-len N))
                    (solve board 0 0 N top bottom left right)
                    (display "Entrada invalida. Introduzco mas vistas que el rango del tablero"))))))
        (display "El tamaño de la tabla no puede exceder 10x10."))))

(main)


