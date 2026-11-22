class_name WordSearch
extends Object

## try https://regex101.com/


## empty tile (not joker tile) should be " " space character for now
## words is text contents of a wordlist file; words split by newline
static func find_matches_for_line(
		spaces:Array, hand:Array, words:String) -> Array[RegExMatch]:
	 
	var hand_set : Array = WordSearch.deduplicate_array(hand)
	#hand_set = WordSearch.capitalize_array(hand_set)
	var hand_collection = "[%s]" % "".join(hand_set) # [AEIOU]
	hand_collection = hand_collection.to_lower()
	
	# match whole line as one word; include all tiles in line
	# any number n of empty spaces can match into [hand]{0, n}
	var regex_recipe = ""
	var space_count = 0
	var past_a_letter = false
	for i in range(spaces.size() + 1):
		var letter : String = "END" if i == spaces.size() else spaces[i]
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
		regex_recipe += letter.to_lower()
		past_a_letter = true 
	
	regex_recipe = "\\b" + regex_recipe + "\\b" # catch a whole word via boundaries
	print_debug(regex_recipe)
	var regex = RegEx.create_from_string(regex_recipe)
	var matches : Array[RegExMatch] = regex.search_all(words)
	return matches



static func find_words_in_string(word:String, words_list_text:String) -> Array[String]:
	#var word_candidates : Array = WordSearch.manual_split_string(string)
	var results : Array[String] = []
	var regex = RegEx.create_from_string(r"(?mi)^%s$" % word)
	for m:RegExMatch in regex.search_all(words_list_text):
		results.append(m.get_string())
	return results



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

## Array of items in the shape of [substring, start_index]
static func manual_split_string(string:String) -> Array:
	var words = []
	var last_letter := " "
	var last_word := ""
	var word_start = -1
	for i in range(string.length() + 1):
		var letter = " "
		if i != string.length(): letter = string[i]
		if letter != "":
			if last_letter == " ": # word start
				word_start = i
			last_word += letter
		if letter == " ":
			if last_letter != " ": # word end
				words.append([last_word, word_start])
			last_word = ""
		last_letter = letter
	return words
