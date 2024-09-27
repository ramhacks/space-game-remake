'''
Use random gen to get an angle that the asteroids will be generated 

y = mx 
m = slope

'''
import random
import math 
import pygame






red = (200,0,0)
                    #'size', 'cordarray'
asteroids_info = []

#Have to edit this to accomadate resolution sizes
#---------------------------------

#How many asteroids we have 
BaseAsteroid_start = -50
BaseAsteroid_end = BaseAsteroid_start * -1

Base_Start_Width = 400/5
Base_End_Width = 350/5

#-------------------------------

def generate_asteroids(window, clear=False):
   if(clear):
      window.fill((0,0,0))


   angle = random.uniform(-1, 1)
   width = random.randint(int(Base_End_Width),int(Base_Start_Width))



   print((math.e)**((-2)**2))
   for x in range(int(BaseAsteroid_start), int(BaseAsteroid_end)):
      size = random.randint(int(1), int(5))

   #-------------------------------
      threshold1 = (-(x))**2 * (0.000000015*(BaseAsteroid_end))

   #-------------------------------
      threshold = math.e**threshold1 
      place = random.randint(0,100) >= math.e**threshold
      
      if(place):
         y = angle * x
         asteroid_cord_dict = {(x-30), y}
         temp_list = [size, asteroid_cord_dict]
         asteroids_info.append(temp_list)
         #print(x+random.randint(-int(width*threshold), int(width*threshold)), int(y+random.randint(-int(width*threshold), int(width*threshold))))
         x=x+250
         y=y+250
         pygame.draw.circle(window,red,(x+random.randint(-int(width*threshold), int(width*threshold)), int(y+random.randint(-int(width*threshold), int(width*threshold)))),size)
      


window = pygame.display.set_mode((500,500))

# slope is random number between -1 and 1


active = True

while active:
   for event in pygame.event.get():
      if event.type == pygame.QUIT:
         active = False


      if event.type == pygame.KEYDOWN:
         if event.key == pygame.K_a:
            generate_asteroids(window, True)
   
   

   pygame.display.update()
