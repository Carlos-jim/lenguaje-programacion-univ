# Pedir al usuario que introduzca el tamaño del tablero
N = int(input("Introduce el tamaño del tablero: "))

# Pedir al usuario que introduzca los valores de las pistas
top = [] # Pistas desde norte
bottom = [] # Pistas desde sur
left = [] # Pistas desde la oeste
right = [] # Pistas desde la este

print("Introduce las pistas desde NORTE, separadas por espacios:")
top = list(map(int, input().split()))

print("Introduce las pistas desde SUR, separadas por espacios:")
bottom = list(map(int, input().split()))

print("Introduce las pistas desde la OESTE, separadas por espacios:")
left = list(map(int, input().split()))

print("Introduce las pistas desde la ESTE, separadas por espacios:")
right = list(map(int, input().split()))

# Crear una matriz vacía para almacenar las alturas de los edificios
board = [[0] * N for _ in range(N)]

# Definir una función para comprobar si un valor es válido en una posición dada
def is_valid(row, col, value):
  # Comprobar si el valor ya está en la fila o en la columna
  if value in board[row] or value in [board[i][col] for i in range(N)]:
    return False
  
  # Comprobar si el valor cumple con las pistas
  # Contar el número de edificios visibles desde cada dirección
  # y compararlo con el valor de la pista correspondiente
  if col == N - 1: # Última columna, comprobar la pista de la derecha
    seen = 1 # El primer edificio siempre es visible
    max_height = value # La altura máxima vista hasta ahora
    for i in range(N - 2, -1, -1): # Recorrer la fila de derecha a izquierda
      if board[row][i] > max_height: # Si hay un edificio más alto
        seen += 1 # Aumentar el contador de edificios visibles
        max_height = board[row][i] # Actualizar la altura máxima
    if seen != right[row]: # Si el número de edificios visibles no coincide con la pista
      return False # El valor no es válido
  
  if row == N - 1: # Última fila, comprobar la pista de abajo
    seen = 1 # El primer edificio siempre es visible
    max_height = value # La altura máxima vista hasta ahora
    for i in range(N - 2, -1, -1): # Recorrer la columna de abajo a arriba
      if board[i][col] > max_height: # Si hay un edificio más alto
        seen += 1 # Aumentar el contador de edificios visibles
        max_height = board[i][col] # Actualizar la altura máxima
    if seen != bottom[col]: # Si el número de edificios visibles no coincide con la pista
      return False # El valor no es válido
  
  # Si se pasa todas las comprobaciones, el valor es válido
  return True

# Definir una función para resolver el puzzle usando backtracking
def solve(row, col):
  # Si se ha llegado al final del tablero, el puzzle está resuelto
  if row == N and col == 0:
    return True
  
  # Si se ha llegado al final de una fila, pasar a la siguiente
  if col == N:
    return solve(row + 1, 0)
  
  # Probar todos los valores posibles de 1 a N
  for value in range(1, N + 1):
    # Comprobar si el valor es válido en la posición actual
    if is_valid(row, col, value):
      # Colocar el valor en el tablero
      board[row][col] = value
      # Intentar resolver el resto del tablero
      if solve(row, col + 1):
        return True
      # Si no se puede resolver, deshacer el cambio y probar otro valor
      board[row][col] = 0
  
  # Si ninguno de los valores funciona, el puzzle no tiene solución
  return False

# Llamar a la función de resolver e imprimir el resultado
if solve(0, 0):
  print("Solución:")
  for row in board:
    print(row)
else:
  print("No hay solución")