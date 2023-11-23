#lang racket

(display "Introduce el tamaño del tablero: ")
(define uu (map string->number (string-split (read-line))))

(display "Introduce las pistas desde NORTE, separadas por espacios: ")
(define top (map string->number (string-split (read-line))))

(display "Introduce las pistas desde SUR, separadas por espacios: ")
(define bottom (map string->number (string-split (read-line))))

(display "Introduce las pistas desde la OESTE, separadas por espacios: ")
(define left (map string->number (string-split (read-line))))

(display "Introduce las pistas desde la ESTE, separadas por espacios: ")
(define right (map string->number (string-split (read-line))))



(define N 2)
(define board (make-list N (make-list N 0)))


(define (list-set lst idx val)
  (for/list ([i (in-range (length lst))]
             [v (in-list lst)])
    (if (= i idx) val v)))



(define (is_valid? row col value)
  (let* ([fila-actual (list-ref board row)]
         [columna-actual (for/list ([i (in-range N)]) (list-ref (list-ref board i) col))])
    (not (or (member value fila-actual) (member value columna-actual))))
  
  (when (= col (- N 1)) ; Última columna, comprobar la pista de la derecha
    (let* ([seen 1] ; El primer edificio siempre es visible
           [max_height value] ; La altura máxima vista hasta ahora
           [fila-actual (list-ref board row)])
      (for ([i (in-range (- N 2) -1 -1)]) ; Recorrer la fila de derecha a izquierda
        (when (> (list-ref fila-actual i) max_height) ; Si hay un edificio más alto
            (begin
              (set! seen (+ seen 1)) ; Aumentar el contador de edificios visibles
              (set! max_height (list-ref fila-actual i))))) ; Actualizar la altura máxima
      (when (not (= seen (list-ref right row))) ; Si el número de edificios visibles no coincide con la pista
          #f ; El valor no es válido
          #t)))

  (when (= row (- N 1)) ; Última fila, comprobar la pista de abajo
    (let* ([seen 1] ; El primer edificio siempre es visible
           [max_height value] ; La altura máxima vista hasta ahora
           [columna-actual (for/list ([i (in-range N)]) (list-ref (list-ref board i) col))])
      (for ([i (in-range (- N 2) -1 -1)]) ; Recorrer la columna de abajo a arriba
        (when (> (list-ref columna-actual i) max_height) ; Si hay un edificio más alto
          (set! seen (+ seen 1)) ; Aumentar el contador de edificios visibles
          (set! max_height (list-ref columna-actual i)))) ; Actualizar la altura máxima
      (unless (= seen (list-ref bottom col)) ; Si el número de edificios visibles no coincide con la pista
        #f))) ; El valor no es válido
  #t) ; Si se pasa todas las comprobaciones, el valor es válido

(define (solve row col)
  ; Si se ha llegado al final del tablero, el puzzle está resuelto
  (if (and (= row N) (= col 0))
      #t
      (if (= col N) ; Si se ha llegado al final de una fila, pasar a la siguiente
          (solve (+ row 1) 0)
          ; Probar todos los valores posibles de 1 a N
          (let loop ([value 1])
            (cond
              [(> value N) #f] ; Si ninguno de los valores funciona, el puzzle no tiene solución
              [(is_valid? row col value)
               (begin
                 ; Colocar el valor en el tablero
                 (list-set (list-ref board row) col value)
                 ; Intentar resolver el resto del tablero
                 (or (solve row (+ col 1))
                     ; Si no se puede resolver, deshacer el cambio y probar otro valor
                     (begin
                       (list-set (list-ref board row) col 0)
                       (loop (+ value 1)))))]
              [else (loop (+ value 1))])))))

 (if (solve 0 0)
    (begin
      (display "Solución:\n")
      (for ([row board])
        (for-each (lambda (value) (printf "~a " value)) row)
        (newline)))
    (display "No hay solución\n"))


