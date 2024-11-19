extends Line2D

#in charge of drawing lines connection each node and managing graph connections between nodes
@export var priority_dict: Dictionary = {
	'miner': 1,
	'solar': 2,
	'Power_Node': 1
	#add more towers here
}

#Sort based on priority in above dictionary
func insertionSort(arr):
	var key
	var j
	for i in range(1, len(arr)):
		key = arr[i]
		j = i - 1

		# Move elements of arr[0..i-1], that are
		# greater than key, to one position ahead
		# of their current position
		while j >= 0 and priority_dict[key.get_parent().cur_name] > priority_dict[arr[j].get_parent().cur_name]:
			arr[j + 1] = arr[j]
			j -= 1
			
		arr[j + 1] = key
		
	
	return arr
#--------------------------
#Draw lines based on prioritys and if they are not intersecting
func priority_lines(overlap_areas):
	var connect_with_priority = []
	for node in overlap_areas:
		if (is_instance_valid(node) and node is sprite_collider and node.get_parent().hovering == false and node != self.get_parent().get_node("Sprite") 
			and node.get_parent().clickable):
			connect_with_priority.append(node)	
		
	
	
	connect_with_priority = insertionSort(connect_with_priority)
	var max = 0
	for node in connect_with_priority:
		if max > 3:
			break
		
		
		add_point(to_local(self.global_position))
		add_point(to_local(node.global_position))
		#
		self.get_parent().connection_points.append(self.get_parent().global_position)
		self.get_parent().connection_points.append(node.global_position)
		
		#Creating Collision Object to add to scene to detect line interescts
		
		max+=1
	
