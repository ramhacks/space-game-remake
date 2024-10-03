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
      
   


   def update(self, events):
      #update, if clicked (can change to any event we define, we can maybe create custom events have to look into 
      # that) 
      for event in events:
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
BaseAsteroid_start = -60
BaseAsteroid_end = BaseAsteroid_start * -1

Base_Start_Width = 500/5
Base_End_Width = 350/5

#-------------------------------

all_sprites_list = pygame.sprite.Group() 
  



def generate_asteroids(window, clear=False):
   
   #generate asteroid   

   angle = random.uniform(-1, 1)
   width = random.randint(int(Base_End_Width),int(Base_Start_Width))



   for x in range(int(BaseAsteroid_start), int(BaseAsteroid_end)):
      size = random.randint(int(3), int(5)) #size range will change when we can zoom out

   #-------------------------------
      threshold1 = (-(x))**2 * (0.0000015*(BaseAsteroid_end))

   #-------------------------------
      threshold = math.e**threshold1 
      place = random.randint(0,90) >= math.e**threshold
      
      if(place):
         y = angle * x

      
         #Move it to the center of screen, REMOVE THIS WHEN WE ADD A CAMERA TO THE GAME!!!
         x=x+250
         y=y+250


         #Generate xpos and ypos
         xpos = x+random.randint(-int(width*threshold), int(width*threshold))
         ypos = int(y+random.randint(-int(width*threshold), int(width*threshold)))
         object_ = Asteroid(size, size*2, size*2, red)
         object_.rect.x = xpos
         object_.rect.y = ypos
         all_sprites_list.add(object_) 
        
      


window = pygame.display.set_mode((500,500))


active = True

player = Player()
player_list = pygame.sprite.Group()
player_list.add(player)

while active:
   events = pygame.event.get()
   for event in events:

      if event.type == pygame.QUIT:
         active = False

      if event.type == pygame.KEYDOWN:
            
            if event.key == pygame.K_LEFT or event.key == ord('a'):
                print("Moveing")
                
                player.control(-5, 0)
            if event.key == pygame.K_RIGHT or event.key == ord('d'):
                player.control(5, 0)
            if event.key == pygame.K_UP or event.key == ord('w'):
                print('jump')

      if event.type == pygame.KEYDOWN:
         if event.key == pygame.K_a:
            
            window.fill((0,0,0))
         
            all_sprites_list = pygame.sprite.Group() 
            
            generate_asteroids(window, True)

            

            
            
   
   window.fill((0,0,0))
   #all_sprites_list.draw(window) 
   #all_sprites_list.update(events)
   player.update()
   player_list.draw(window)
   pygame.display.update()
   pygame.display.flip()
