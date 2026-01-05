@tool
extends Node

#list on naming conventions
@export_enum("snake_case", "camelCase", "PascalCase", "kebab-case") var naming_convention_to_convert_to : int

#list of words to not modify
var GDSCRIPT_RESERVED_WORDS : Array[String] = [
	# --- Littéraux ---
	"true", "false", "null",

	# --- Déclarations ---
	"var", "const", "static", "enum", "class", "class_name", "extends", "signal", "func",

	# --- Contrôle de flux ---
	"if", "elif", "else", "match", "for", "while", "break", "continue", "return", "pass", "await", "yield",

	# --- Opérateurs logiques ---
	"and", "or", "not",

	# --- Tests / conversions ---
	"is", "in", "as", "assert",

	# --- Contexte ---
	"self", "super",

	# --- Annotations ---
	"@export", "@export_enum", "@export_range", "@export_flags", "@export_category", "@export_group",
	"@export_subgroup", "@export_file", "@export_dir", "@export_global_file", "@export_global_dir",
	"@export_multiline", "@onready", "@tool", "@warning_ignore",

	# --- Types primitifs ---
	"bool", "int", "float", "String",

	# --- Conteneurs de base ---
	"Array", "Dictionary",

	# --- Types math / utilitaires ---
	"Vector2", "Vector2i", "Vector3", "Vector3i", "Vector4", "Vector4i", "Rect2",
	"Rect2i", "Transform2D", "Transform3D", "Basis", "Quaternion", "Plane", "AABB",
	"Color",

	# --- Autres types fondamentaux ---
	"RID", "Callable", "Signal", "StringName", "NodePath", "PackedByteArray", "PackedInt32Array",
	"PackedInt64Array", "PackedFloat32Array", "PackedFloat64Array", "PackedStringArray",
	"PackedVector2Array", "PackedVector3Array", "PackedColorArray"
]

#script to modify
@export var target_script : Script
#run this script
@export var run : bool = false

func _process(_delta):
	if run:
		run = false
		
		if target_script == null:
			push_error("Aucun script cible assigné.")
			return
			
		convert_script(target_script)
		
func convert_script(script: Script) -> void:
	#get script file path
	var path := script.resource_path
	if path.is_empty():
		push_error("Le script cible n’a pas de chemin valide.")
		return
		
	#open file in reader mode
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Impossible d’ouvrir le fichier : " + path)
		return
		
	#reading of the file, line by line
	var original_lines: Array[String] = []
	while not file.eof_reached():
		original_lines.append(file.get_line())
	file.close()
	
	#conversion of the collected lines, line by line
	var converted_lines: Array[String] = []
	for line in original_lines:
		converted_lines.append(convert_line(line))
		
	#rewrite the script with the converted lines
	file = FileAccess.open(path, FileAccess.WRITE)
	for l in converted_lines:
		file.store_line(l)
	file.close()
	
	print("Script converti")
	
func convert_line(line: String) -> String:
	# Suppression des espaces pour l’analyse uniquement
	var stripped := line.strip_edges()

	# Si la ligne est entièrement commentée, on ne la modifie pas
	if stripped.begins_with("#"):
		return line

	# Séparation du code et du commentaire éventuel en fin de ligne
	var comment_index : = line.find("#")
	var code_part : String = line
	var comment_part : = ""
	
	if comment_index != -1:
		code_part = line.substr(0, comment_index)
		comment_part = line.substr(comment_index)

	# Conversion uniquement sur la partie code
	code_part = convert_identifiers(code_part)

	# Réassemblage final (code + commentaire intact)
	return code_part + comment_part


func convert_identifiers(code: String) -> String:
	# Découpage très simple basé sur les espaces.
	# Suffisant pour un premier outil, mais améliorable.
	var tokens := code.split(" ", false)

	for i in tokens.size():
		var token := tokens[i]
		
		# Liste minimale de mots à ne jamais modifier (mot-clés GDScript, classes, ...)
		if token in GDSCRIPT_RESERVED_WORDS or ClassDB.get_class_list():
			continue
			
		# Nettoyage léger pour extraire l’identifiant réel
		var clean := token
		clean = clean.lstrip("():,[]{}")
		clean = clean.rstrip("():,[]{}")

		# Ignore les tokens vides ou déjà en snake_case
		if clean.is_empty():
			continue
		if clean == clean.to_lower() and clean.find("_") != -1:
			continue

		# Détection naïve du camelCase :
		# - au moins une majuscule
		# - pas d’underscore
		if clean.find("_") == -1 and clean != clean.to_lower():
			var converted := camel_to_snake(clean)
			tokens[i] = token.replace(clean, converted)

	return " ".join(tokens)
	
func camel_to_snake(text: String) -> String:
	#convert each majuscule to "_minuscule"
	
	var result : String = ""
	
	for i in text.length():
		var c : = text[i]
		
		# Une majuscule est différente de sa version minuscule
		if c != c.to_lower():
			if i > 0:
				result += "_"
			result += c.to_lower()
		else:
			result += c
			
	return result
