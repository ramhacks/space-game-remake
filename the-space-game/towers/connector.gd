extends Line2D

#in charge of drawing lines connection each node and managing graph connections between nodes


#limit connections but prioritize certain towers
func limit_lines(connection_list, name_list):
	if(len(connection_list) > 3):
		if('solar' not in name_list):
			connection_list = connection_list.slice(0, 3)
		else:
			#THIS NEEDS TO BE FIXED, many errors can occur by swapping the values, need to understand graph
			#theory more to assess however
			#swap values
			var temp = connection_list[0]
			connection_list[0] = connection_list[name_list.find('solar')]
			connection_list[name_list.find('solar')] = temp
			
			#now we can slice 
			connection_list = connection_list.slice(0, 3)
			
	
	return connection_list


#redraw connection lines in case a new tower is added called every time power is sent to a node 
func format_connection_lines(sprite_pointer, redraw=true, no_hover_connect=false):
	sprite_pointer.connections = get_parent().overlap_areas
	#change a lot of switch cases so that different for each tower
	#make the array be in order of closest to furtherst node
	var full_collision_list_with_distances = [] #2d array of node and nodes distance from self
	var collision_name_list = [] #tower names that are within collision boundaries
	
	if redraw:
		clear_points()

	var temp_collisions = get_parent().overlap_areas
	
	
	var output_nodes = []
	#with distance we have to make it so that it is ordered by distance however no limit for normal nodes 
	if(len(temp_collisions) > 0):
		for j in range(len(temp_collisions)):
			if(is_instance_valid(temp_collisions[j])):
				if(temp_collisions[j].correct_area and temp_collisions[j] != sprite_pointer):
					var selfposition = to_local(self.global_position)
					var nodeposition = to_local(temp_collisions[j].global_position)
					var d = selfposition.distance_to(nodeposition)			
					
					if(j == 0):
						full_collision_list_with_distances.append([temp_collisions[j], d])
						collision_name_list.append(temp_collisions[j].my_name)

					for i in range(len(full_collision_list_with_distances)):
						if(d < full_collision_list_with_distances[i][1]):
							full_collision_list_with_distances.insert(i, [temp_collisions[j], d])
		
		if get_parent().cur_name != 'Power_Node' or get_parent().cur_name != 'solar':
			full_collision_list_with_distances = limit_lines(full_collision_list_with_distances, collision_name_list)
			
				
				
		for node in full_collision_list_with_distances:
			output_nodes.append(node)
			if(redraw and !no_hover_connect):
				add_point(to_local(self.global_position))
				add_point(to_local(node[0].global_position))
			elif(redraw and no_hover_connect):
				if(!node[0].hovering):
					add_point(to_local(self.global_position))
					add_point(to_local(node[0].global_position))

		
	return output_nodes

func _on_sprite_ask_for_colliding_areas(sprite_pointer: Variant) -> void:
	format_connection_lines(sprite_pointer, true, true)
	sprite_pointer.connections = get_parent().overlap_areas
