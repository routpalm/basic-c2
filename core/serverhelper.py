from random import randrange
from core.ascii import handle_conversion
def initServer():
    random = randrange(2)
    if random == 0:
        image = "./core/images/duck.jpg"
    elif random == 1:
        image = "./core/images/bear.jpg"

    handle_conversion(image_filepath=image)
    print("WELCOME TO NICHOLAS'S C2 SERVER!!!!!!!!!")
    print("="*80)
