'''
Use random gen to get an angle that the asteroids will be generated 

y = mx 
m = slope

'''
import random
import math 
import pygame



window = pygame.display.set_mode((500,500))


red = (200,0,0)
                    #'size', 'cordarray'
asteroids_info = []

#Have to edit this to accomadate resolution sizes
#---------------------------------
BaseAsteroid_start = -1000/10
BaseAsteroid_end = 1000/10

Base_Start_Width = 1000/10
Base_End_Width = 500/10

#-------------------------------


angle = random.uniform(-1, 1)
width = random.randint(int(Base_End_Width),int(Base_Start_Width))



print((math.e)**((-2)**2))
for x in range(int(BaseAsteroid_start), int(BaseAsteroid_end)):
   size = random.randint(int(15/5), int(20/5))

#-------------------------------
   threshold1 = (-(x))**2 * (0.000000000015*(BaseAsteroid_end))

#-------------------------------
   threshold = math.e**threshold1 
   place = random.randint(0,100) >= math.e**threshold
   
   if(place):
      y = angle * x
      asteroid_cord_dict = {(x-30), y}
      temp_list = [size, asteroid_cord_dict]
      asteroids_info.append(temp_list)
      print(x+random.randint(-int(width*threshold), int(width*threshold)), int(y+random.randint(-int(width*threshold), int(width*threshold))))
      pygame.draw.circle(window,red,(x+random.randint(-int(width*threshold), int(width*threshold)), int(y+random.randint(-int(width*threshold), int(width*threshold)))),size)
   


circleX = 100
circleY = 100
radius = 10


# slope is random number between -1 and 1


active = True

while active:
   for event in pygame.event.get():
      if event.type == pygame.QUIT:
         active = False

   

   pygame.display.update()
