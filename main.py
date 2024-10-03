# import the pygame module 
import pygame 
  
# Define the background colour 
# using RGB color coding. 
background_colour = (0, 0, 0) 
  
# Define the dimensions of 
# screen object(width,height) 
screen = pygame.display.set_mode((640, 360)) 
  
# Set the caption of the screen 
pygame.display.set_caption('Space Game') 
  
# Fill the background colour to the screen 
screen.fill(background_colour) 

# Draw rectangle
    # Black backing
rect_color = (0, 0, 0)
pygame.draw.rect(screen, rect_color, pygame.Rect(0,305,640,68))
    # Green button bar
    # Minimap border
rect_color = (255, 255, 255)
pygame.draw.rect(screen, rect_color, pygame.Rect(2,244,196,168))
    # Minimap background
rect_color = (0, 0, 0)
pygame.draw.rect(screen, rect_color, pygame.Rect(4,246,192,112))

# Create an object for the buttons
button_img = pygame.image.load("images/button.png")
class Button(object):
    def _init(self):
        super().__init__()
        self.image = pygame.Surface((50, 50))
        self.rect = self.image.get_rect()
        self.rect.x = 100
        self.rect.y = 100

# Create a button object
button1 = Button

# Update the display using flip 
pygame.display.flip() 
  
# Variable to keep our game loop running 
running = True
  
# game loop 
while running: 
  
# for loop through the event queue   
    for event in pygame.event.get(): 
      
        # Check for QUIT event       
        if event.type == pygame.QUIT: 
            running = False