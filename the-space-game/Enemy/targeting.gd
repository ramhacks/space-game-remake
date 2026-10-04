extends Node

signal changetarget(newtarget)


func send_change(newtarget: String):
	changetarget.emit(newtarget)
