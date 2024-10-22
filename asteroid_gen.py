'''
Use random gen to get an angle that the asteroids will be generated 

y = mx 
m = slope



Add a check function, if there are not a minimum of 10 asteroids in a 100 radius of start, regenerate asteroids

'''
import random
import math 
import pygame
import numpy as np





red = (200,0,0)
COLOR = (255, 100, 98) 
SURFACE_COLOR = (167, 255, 100) 
class Player(pygame.sprite.Sprite):
    """
    Spawn a player
    """

    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.movex = 0
        self.movey = 0
        self.frame = 0
        self.image = pygame.image.load("space-game-remake\Asteroid_Images\945.png").convert_alpha()
        self.mask = pygame.mask.from_surface(self.image)
        self.rect = self.image.get_rect()
        

    def control(self, x, y):
        self.movex += x
        self.movey += y
        

    def update(self):

        self.rect.x = self.rect.x + self.movex
        self.rect.y = self.rect.y + self.movey
        self.movex = 0
        self.movey = 0

        # moving left
        



class Asteroid(pygame.sprite.Sprite): 
   def __init__(self, size, width, height, color): 
      super().__init__() 
      self.image = pygame.Surface((width, height), pygame.SRCALPHA)
      self.color = color
      self.size = size

      self.dry = False

      self.image = pygame.image.load("space-game-remake\Asteroid_Images\941.png").convert_alpha()
      self.mask  = pygame.mask.from_surface( self.image )
      #pygame.draw.circle(self.image, self.color, (width//2, height//2), self.size)
      self.rect = self.image.get_rect()
      self.width = width
      self.height = height
      
      self.resources = self.size * 52


  
#mine the asteroid every time you "click" on it, 
   def mine(self):
      self.resources = self.resources - 20 #change resource amount
      print("Mine, ", self)
      if(self.resources < 0):
         self.dry = True
      
      #draw the asteroid
      
   


   def update(self, events, player_group, mygroup):
      #update, if clicked (can change to any event we define, we can maybe create custom events have to look into 
      # that) 
      for event in events:
        # if (pygame.sprite.groupcollide(mygroup, player_group, False, False, pygame.sprite.collide_mask)):
        #     print("KILL ME")
         if event.type == pygame.MOUSEBUTTONUP:
            pos = pygame.mouse.get_pos()
            pos_in_mask = event.pos[0] - self.rect.x, event.pos[1] - self.rect.y
            touching = self.rect.collidepoint(*pos) and self.mask.get_at(pos_in_mask)
            print(touching)
            #we mouse clicked
            if self.rect.collidepoint(event.pos) and self.mask.get_at(pos_in_mask):
               #if mouse click is over asteroid pos
              
               self.mine()

               #if no more resources kill the sprite
               #change alpha channel


#Have to edit this to accomadate resolution sizes
#---------------------------------

#How many asteroids we have 
BaseAsteroid_start = -40
BaseAsteroid_end = BaseAsteroid_start * -1

Base_Start_Width = 800/5
Base_End_Width = 600/5

#-------------------------------

all_sprites_list = pygame.sprite.Group() 
  

screen_height = 500
screen_width = 500

#Function to make a large wave then generate points inside that wave at random intervals

#The only thing we need to add is how to angle the wave we generated
def make_wave(window):
   

   angle = 11 #w

   height = 100 # how tall it is, every iteration make smaller to generate asteroid along it
   width = 50 #how wide the wave is
   

   transformx = int(-(screen_width/2)+(screen_width/50))
   transformy = int(-(screen_height/2))

   center = (int(screen_width/2), transformy*-1)
   
   place_chance = 10 #chance of placing asteroid, right now it is 10%
   #change it so that generates more toward center point 
   #do this by getting distance from center, the closer it is the higher the chance of placing it


   asteroid_x_spread = 5 #spread of asteroids over the x-axis
   o = 100

   loopamount = 10 #amount of times to iterate over smaller wave
   for j in range(0, loopamount):
      random_chance_change = random.uniform(1.5,2)
      
      asteroid_separation = random.uniform(1, 3) #amount asteroids are separated over the x axis
      for i in np.arange(0, transformy*-1, asteroid_separation):
         
         x_pos = i*asteroid_x_spread # multiple by a constant to spread out the points
         y_pos = (height/(1+((x_pos+transformx)/width)**2))-transformy # plot the function
         
         #have to find a way to tilt the wave

            
       

         distance = math.sqrt(((center[0]-x_pos)**2)+(center[1]-y_pos)**2) # calculate the distance from the center point (this will change when we make the center point 0, 0)
         place = random.randint(0, int(distance))


         if(place < place_chance and x_pos < screen_width): #if place is less then 10 place asteroid
            jiggle_asteroid = random.randint(-10, 10) # shuffle asteroid a bit
            object_ = Asteroid(3, 3*2, 3*2, red)
               
            object_.rect.x = x_pos + jiggle_asteroid
            object_.rect.y = y_pos
            all_sprites_list.add(object_) 
      

      
#2 for loops to plot both parts of the wave function
      for i in np.arange(0, transformy*-1, asteroid_separation):
         
         x_pos = i*asteroid_x_spread # multiple by a constant to spread out the points
         y_pos = ((height*-1)/(1+((x_pos+transformx)/width)**2))-transformy #plot over the wave function

            
         distance = math.sqrt(((center[0]-x_pos)**2)+(center[1]-y_pos)**2) # calculate the distance from the center point (this will change when we make the center point 0, 0)
         place = random.randint(0, int(distance))

        # print(place<distance/5)
         if(place < place_chance and x_pos < screen_width):
            jiggle_asteroid = random.randint(-10, 10) # shuffle asteroid a bit
            object_ = Asteroid(3, 3*2, 3*2, red)
               
            object_.rect.x = x_pos + jiggle_asteroid
            object_.rect.y = y_pos
            all_sprites_list.add(object_) 

      if(height > 0):
         print(height)
         #shrink the wave so we can generate asteroids inside the wave, this is how we make the asteroids to appear to look nateral
         height -= (j+(loopamount/random_chance_change))
      else:
         break
   
   

window = pygame.display.set_mode((500,500))


active = True

player = Player()
player_list = pygame.sprite.Group()
player_list.add(player)

transformx = int(-(screen_width/2)+(screen_width/50))

transformy = int(-(screen_height/2))

center = (int(screen_width/2), transformy*-1)

player.rect.y = 250
player.rect.x = 250

while active:
   
   events = pygame.event.get()
   for event in events:

      if event.type == pygame.QUIT:
         active = False

      if event.type == pygame.KEYDOWN:
            
            if event.key == pygame.K_LEFT or event.key == ord('a'):
                player.control(-10, 0)
            if event.key == pygame.K_RIGHT or event.key == ord('d'):
                player.control(10, 0)
            if event.key == pygame.K_UP or event.key == ord('w'):
                player.control(0,-10)
            if event.key == pygame.K_DOWN or event.key == ord('s'):
                player.control(0,10)

      if event.type == pygame.KEYDOWN:
         if event.key == pygame.K_g:
            
            window.fill((0,0,0))
         
            all_sprites_list = pygame.sprite.Group() 
            make_wave(window)
            #generate_asteroids(window, True)

            

            
            
   
   #window.fill((0,0,0))
   pygame.draw.circle(window, red, center, 20, 20)
   #window.fill((0,0,0))
   all_sprites_list.draw(window) 
   all_sprites_list.update(events, player_list, all_sprites_list)
   #player.update()
   #player_list.draw(window)
   pygame.display.update()

