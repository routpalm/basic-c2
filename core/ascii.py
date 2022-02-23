from PIL import Image

ASCII_CHARS = ["@", "#", "$", "%", "?", "*", "+", ";", ":", ",", "."]

def resize(image, new_width=50):
    original_width, original_height = image.size
    new_height = (int)(new_width * original_height / original_width)
    return image.resize((new_width,new_height))


def to_greyscale(image):
    return image.convert('L')


def map(image):
    pixels = image.getdata()
    ascii_str = ""
    for pixel in pixels:
        ascii_str += ASCII_CHARS[pixel//25]
    return ascii_str


def convert(image):
    scaled_image = resize(image)
    greyscale_image = to_greyscale(scaled_image)

    ascii_str = map(greyscale_image)
    image_width = greyscale_image.width
    ascii_str_len = len(ascii_str)
    ascii_image = ""

    for i in range(0, ascii_str_len, image_width):
        ascii_image += ascii_str[i:i+image_width] + "\n"
    return ascii_image


def handle_conversion(image_filepath):
    image = None
    try:
        image = Image.open(image_filepath)
    except Exception as e:
        print("Error opening image")
        print(e)
        return
    ascii_image = convert(image)
    print(ascii_image)