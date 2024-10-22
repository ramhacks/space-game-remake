#890 - 932 full (21 textures)
#935 - 975 empty

import os
import numpy as np

directory = 'Asteroid_Images'

nprange = np.arange(892, 934, 2)
print(nprange)

amount = 21

current = 0

file_even_list = []
for filename in os.scandir(directory):
    f = os.path.join(directory, filename)
    if filename.is_file():
        number = int(filename.name.split('.')[0])
        
        if(number in nprange):
            file_even_list.append(number)
            
        else:
            prefix = str(file_even_list[current]+1)
            name = prefix + '.png'
            os.rename(filename.path, name)

            current+=1



