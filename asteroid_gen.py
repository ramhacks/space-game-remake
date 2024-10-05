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
  


        

#Function to make a large wave then generate points inside that wave at random intervals

#The only thing we need to add is how to angle the wave we generated
def make_wave(window):

   min_x_pos=100 #this scales the wave/makes it wider
   #as we get bigger, scale up asteroid field
   max_x_pos=200
   
   min_y_pos=150 #minimum y and max, this is how tall the wave can be
   max_y_pos=300

   d= -0.1
   for i in range(0, 10):
      #This part generates the first half of the wave (the positive side)
      for j in range(0,int(i/2)):
         size = random.randint(int(3), int(5)) #size range will change when we can zoom out

         #get the y position of the dot
         y = random.randint(min_y_pos,max_y_pos)
         threshold2 = (-(d*i)**2) 
         y_pos = (math.e**threshold2) * y

         x = random.randint(min_x_pos,max_x_pos)

         #get the x position of the dot
         thresholdx = (-(d*i)**2) 
         x_pos = (math.e**thresholdx) * x
         
         #Add the asteroid to the sprite list
         object_ = Asteroid(size, size*2, size*2, red)
            
         object_.rect.x = x_pos
         object_.rect.y = y_pos
         all_sprites_list.add(object_) 
   for i in range(0, 10):
            #This part generates the second half of the wave (the negative side)
      for j in range(0,i):
         size = random.randint(int(3), int(5)) #size range will change when we can zoom out

      #get the y position of the dot
         y = random.randint(min_y_pos,max_y_pos)
         threshold2 = (-(d*i)**2) 
         y_pos = (math.e**threshold2) * y

         x = random.randint(min_x_pos,max_x_pos)

         #get the x position of the dot
         thresholdx = (-(d*i)**2) 
         x_pos = (math.e**thresholdx) * x


         #Add the asteroid to the sprite list
         object_ = Asteroid(size, size*2, size*2, red)
            
         object_.rect.x = max_x_pos-x_pos 
         object_.rect.y = max_y_pos-y_pos 
         all_sprites_list.add(object_) 


window = pygame.display.set_mode((500,500))


active = True

player = Player()
player_list = pygame.sprite.Group()
player_list.add(player)
player.rect.x = 200
player.rect.y = 200
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

            

            
            
   
   window.fill((0,0,0))
   all_sprites_list.draw(window) 
   all_sprites_list.update(events, player_list, all_sprites_list)
   player.update()
   player_list.draw(window)
   pygame.display.update()

