class_name WordSearch
extends Object

## try https://regex101.com/


## empty tile (not joker tile) should be " " space character for now
## words is text contents of a wordlist file; words split by newline
static func find_matches_for_line(
		spaces:Array, hand:Array, words:String) -> Array[RegExMatch]:
	 
	var hand_set : Array[String] = WordSearch.deduplicate_array(hand)
	hand_set = WordSearch.capitalize_array(hand_set)
	var hand_collection = "[%s]" % "".join(hand_set) # [AEIOU]
	
	# match whole line as one word; include all tiles in line
	# any number n of empty spaces can match into [hand]{0, n}
	var regex_recipe = ""
	var space_count = 0
	var past_a_letter = false
	for i in range(spaces.size() + 1):
		var letter = "END" if i == spaces.size() else spaces[i]
		if letter == " ":
			space_count += 1
			continue
		# else find letter or end: save empty space sequence
		if space_count > 0:
			if past_a_letter and letter != "END":
				regex_recipe += "%s{%d}" % [hand_collection, space_count]
			else:
				regex_recipe += "%s{0,%d}" % [hand_collection, space_count]
			space_count = 0
		if letter == "END": 
			break
		regex_recipe += letter
		past_a_letter = true 
	
	regex_recipe = "\\b" + regex_recipe + "\\b" # catch a whole word via boundaries
	
	var regex = RegEx.create_from_string(regex_recipe)
	var matches : Array[RegExMatch] = regex.search_all(words)
	return matches





static func capitalize_array(arr:Array[String]) -> Array[String]:
	var new_array = []
	for item in arr:
		new_array.push(item.capitalize())
	return new_array

static func deduplicate_array(arr:Array) -> Array:
	var d := {}
	for item in arr:
		d[item] = 1
	return d.keys()
