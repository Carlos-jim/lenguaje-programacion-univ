#lang racket
(define (is-valid board row col value N top bottom left right)
  (let* ([row-values (vector->list (list-ref board row))] ; Usa vector->list aquí
         [col-values (map (lambda (r) (vector-ref (list-ref board r) col)) (range N))]
         [in-row? (member value row-values)]
         [in-col? (member value col-values)])
    (if (or in-row? in-col?)
        #f
        (let* ([right-seen (if (= col (- N 1))
                               (let loop ([i (- N 2)] [max-height value] [seen 1])
                                 (if (< i 0)
                                     seen
                                     (if (> (list-ref row-values i) max-height) ; Usa list-ref aquí
                                         (loop (- i 1) (list-ref row-values i) (+ seen 1)) ; Usa list-ref aquí
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
          (if (or (and (> right-seen 0) (not (= right-seen (list-ref right row)))) ; Usa list-ref aquí
                  (and (> bottom-seen 0) (not (= bottom-seen (list-ref bottom col))))) ; Usa list-ref aquí
              #f
              #t)))))

(define (solve board row col N top bottom left right)
  (if (= row N)
      (begin (display "Solution:\n") (for-each (lambda (r) (display r) (newline)) board))
      (if (= col N)
          (solve board (+ row 1) 0 N top bottom left right)
          (let loop ([value 1])
            (if (> value N)
                #f
                (if (is-valid board row col value N top bottom left right)
                    (begin
                      (vector-set! (list-ref board row) col value) ; Usa list-ref aquí
                      (if (solve board row (+ col 1) N top bottom left right)
                          #t
                          (begin
                            (vector-set! (list-ref board row) col 0) ; Usa list-ref aquí
                            (loop (+ value 1)))))
                    (loop (+ value 1))))))))

(define (main)
  (display "Introduce las vistas del NORTE, SEPARADA POR ESPACIOS ")
  (let* ([top (map string->number (string-split (read-line)))]
         [N (length top)]) ; Usa la longitud de la lista como el tamaño de la tabla
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
                (if (and (= bottom-len N) (= left-len N) (= right-len N))
                    (solve board 0 0 N top bottom left right) ; Pasa N como un argumento a la función solve
                    (display "Entrada invalida. Introduzco mas vistas que el rango del tablero"))))))
        (display "El tamaño de la tabla no puede exceder 10x10."))))

(main)

