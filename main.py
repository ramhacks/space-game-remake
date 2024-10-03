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

imp = pygame.image.load("/Users/calinsmith/Documents/space-game/nebula-2638126_640.jpg")

# UI Button Background Image
button_back_image = pygame.image.load("/Users/calinsmith/Documents/space-game/1.png")
  
# Image
screen.blit(imp, (0, 0))

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

screen.blit(button_back_image, (225,310))
screen.blit(button_back_image, (285,310))

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