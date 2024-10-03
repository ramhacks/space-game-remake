'''
Use random gen to get an angle that the asteroids will be generated 

y = mx 
m = slope



Add a check function, if there are not a minimum of 10 asteroids in a 100 radius of start, regenerate asteroids

'''
import random
import math 
import pygame




red = (200,0,0)
COLOR = (255, 100, 98) 
SURFACE_COLOR = (167, 255, 100) 

class Asteroid(pygame.sprite.Sprite): 
   def __init__(self, size, width, height, color): 
      super().__init__() 
      self.image = pygame.Surface((width, height), pygame.SRCALPHA)
      self.color = color
      self.size = size
      pygame.draw.circle(self.image, self.color, (width//2, height//2), self.size)
      self.rect = self.image.get_rect()
      self.width = width
      self.height = height
      
      self.resources = self.size * 52


   def recal_size(self):
      #recalculate the size of the asteroid
      try:
         self.size = int(self.resources/52)
      except: #size is under 0 so destroy the asteroid because it is now a negative size
         pass
   
#mine the asteroid every time you "click" on it, 
   def mine(self):
      self.image.fill((0,0,0)) # clear asteroid 
      self.resources = self.resources - 20 #change resource amount

      self.recal_size()
      print(self.size, self.resources)
      pygame.draw.circle(self.image, self.color, (self.width//2, self.height//2), self.size) #redraw
      


   def update(self, events):
      for event in events:
         if event.type == pygame.MOUSEBUTTONUP:
            if self.rect.collidepoint(event.pos):
               self.image.fill((0,0,0)) # clear asteroid 
               self.mine()
               if(self.resources < 0):
                  self.kill()

               


                    #'size', 'cordarray'



#Have to edit this to accomadate resolution sizes
#---------------------------------

#How many asteroids we have 
BaseAsteroid_start = -60
BaseAsteroid_end = BaseAsteroid_start * -1

Base_Start_Width = 500/5
Base_End_Width = 350/5

#-------------------------------

all_sprites_list = pygame.sprite.Group() 
  



def generate_asteroids(window, clear=False):
   


   angle = random.uniform(-1, 1)
   width = random.randint(int(Base_End_Width),int(Base_Start_Width))



   for x in range(int(BaseAsteroid_start), int(BaseAsteroid_end)):
      size = random.randint(int(3), int(8)) #size range

   #-------------------------------
      threshold1 = (-(x))**2 * (0.0000015*(BaseAsteroid_end))

   #-------------------------------
      threshold = math.e**threshold1 
      place = random.randint(0,90) >= math.e**threshold
      
      if(place):
         y = angle * x

      
         #print(x+random.randint(-int(width*threshold), int(width*threshold)), int(y+random.randint(-int(width*threshold), int(width*threshold))))
         x=x+250
         y=y+250

         xpos = x+random.randint(-int(width*threshold), int(width*threshold))
         ypos = int(y+random.randint(-int(width*threshold), int(width*threshold)))
         object_ = Asteroid(size, size*2, size*2, red)
         object_.rect.x = xpos
         object_.rect.y = ypos
         all_sprites_list.add(object_) 
         #pygame.draw.circle(window,red,(x+random.randint(-int(width*threshold), int(width*threshold)), int(y+random.randint(-int(width*threshold), int(width*threshold)))),size)
      


window = pygame.display.set_mode((500,500))

# slope is random number between -1 and 1

  

active = True


while active:
   events = pygame.event.get()
   for event in events:
      if event.type == pygame.QUIT:
         active = False


      if event.type == pygame.KEYDOWN:
         if event.key == pygame.K_a:
            
            window.fill((0,0,0))
            #pygame.draw.circle(window, COLOR, (250, 250), 30)
            #pygame.draw.circle(window, SURFACE_COLOR, (250, 250), 5)
            all_sprites_list = pygame.sprite.Group() 
            
            generate_asteroids(window, True)

            

            
            
   
   
   all_sprites_list.draw(window) 
   all_sprites_list.update(events)
   pygame.display.update()
