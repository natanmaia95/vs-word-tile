extends Node2D


var letter : String = " " :
	set(value):
		letter = value[0].capitalize()
		%LblLetter.text = letter
