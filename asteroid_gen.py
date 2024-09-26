'''
Use random gen to get an angle that the asteroids will be generated 

'''

min_b = 5500
max_b = 6000

min_a = 1000
max_a = 2000

import pygame

window = pygame.display.set_mode((500,500))

red = (200,0,0)

circleX = 100
circleY = 100
radius = 10

active = True

while active:
   for event in pygame.event.get():
      if event.type == pygame.QUIT:
         active = False

   pygame.draw.circle(window,red,(circleX,circleY),radius) # DRAW CIRCLE

   pygame.display.update()
