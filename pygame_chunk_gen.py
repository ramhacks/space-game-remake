import pygame
import random

# Pygame setup
pygame.init()

# Screen dimensions
SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption('Chunk Generating 2D Map')

# Tile and chunk size
TILE_SIZE = 32
CHUNK_SIZE = 16

# Player settings
player_pos = [SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2]
player_speed = 5

# Dictionary to store generated chunks
chunks = {}

def generate_chunk(chunk_x, chunk_y):
    """Generate a chunk at the given chunk coordinates."""
    chunk_data = []
    for y in range(CHUNK_SIZE):
        row = []
        for x in range(CHUNK_SIZE):
            # Generate tile type (e.g., 0: grass, 1: water, etc.)
            tile_type = random.choice([0, 1])  # Simplified random generation
            row.append(tile_type)
        chunk_data.append(row)
    return chunk_data

def get_chunk(player_x, player_y):
    """Calculate the chunk the player is currently in."""
    chunk_x = player_x // (TILE_SIZE * CHUNK_SIZE)
    chunk_y = player_y // (TILE_SIZE * CHUNK_SIZE)
    return chunk_x, chunk_y

def draw_chunk(chunk_data, chunk_x, chunk_y, offset_x, offset_y):
    """Draw the given chunk at screen coordinates."""
    for y, row in enumerate(chunk_data):
        for x, tile in enumerate(row):
            # Calculate the screen position of the tile
            tile_x = (chunk_x * CHUNK_SIZE + x) * TILE_SIZE - offset_x
            tile_y = (chunk_y * CHUNK_SIZE + y) * TILE_SIZE - offset_y

            # Draw different colors for different tile types
            if tile == 0:  # Grass
                color = (34, 177, 76)
            elif tile == 1:  # Water
                color = (0, 162, 232)

            pygame.draw.rect(screen, color, (tile_x, tile_y, TILE_SIZE, TILE_SIZE))

# Main game loop
clock = pygame.time.Clock()
running = True

while running:
    screen.fill((0, 0, 0))

    # Handle events
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Player movement
    keys = pygame.key.get_pressed()
    if keys[pygame.K_w]:
        player_pos[1] -= player_speed
    if keys[pygame.K_s]:
        player_pos[1] += player_speed
    if keys[pygame.K_a]:
        player_pos[0] -= player_speed
    if keys[pygame.K_d]:
        player_pos[0] += player_speed

    # Get the chunk the player is in
    player_chunk_x, player_chunk_y = get_chunk(player_pos[0], player_pos[1])

    # Offset to account for player's position in the world
    offset_x = player_pos[0] - SCREEN_WIDTH // 2
    offset_y = player_pos[1] - SCREEN_HEIGHT // 2

    # Render nearby chunks (e.g., 3x3 chunk area around player)
    for dy in range(-2, 3):
        for dx in range(-2, 3):
            chunk_x = player_chunk_x + dx
            chunk_y = player_chunk_y + dy

            # If the chunk doesn't exist yet, generate it
            if (chunk_x, chunk_y) not in chunks:
                chunks[(chunk_x, chunk_y)] = generate_chunk(chunk_x, chunk_y)

            # Draw the chunk
            chunk_data = chunks[(chunk_x, chunk_y)]
            draw_chunk(chunk_data, chunk_x, chunk_y, offset_x, offset_y)

    # Update the display
    pygame.display.flip()

    # Cap the frame rate
    clock.tick(60)

pygame.quit()
