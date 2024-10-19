extends Node
class_name Object_Pool

# Variable para almacenar el pool
var pool = []
var pool_size = 500  # Tamaño máximo del pool

# Singleton Initialization
func _ready():
	# Pre-instanciar los objetos en el pool
	for i in range(pool_size):
		var long_fragment = preload("res://Fragments/LongFragment/Scenes/long_fragment.tscn").instantiate()
		long_fragment.hide()  # Ocultarlos hasta que sean usados
		add_child(long_fragment)  # Añadirlos como hijos del pool
		pool.append(long_fragment)

# Método para obtener un fragmento disponible
func get_long_fragment():
	for fragment in pool:
		if fragment.is_hidden():
			#fragment.show()
			return fragment
	print("No fragments available in the pool.")
	return null

# Método para "liberar" un fragmento usado y devolverlo al pool
func release_fragment(fragment):
	fragment.hide()  # Ocultar el fragmento para reutilizarlo
