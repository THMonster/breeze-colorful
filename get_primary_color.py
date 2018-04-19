#!/usr/bin/python3
import colorsys, sys
from PIL import Image

def calc_pixel_var(pixel):
    pixel_var = 0

    if pixel[0] <= 70 and pixel[1] <= 70 and pixel[2] <= 100:
        return 1
    else:
        return -1

    n = 2
    while n >= 0:
        # print(pixel)
        temp = 100 - pixel[n]
        if temp > 0:
            pixel_var += temp * 0.2
        else:
            pixel_var += temp * 100000
        n = n - 1

    if pixel_var >= 0:
        return 1 # 1 for dark
    else:
        return -1 # -1 for light


def calc_color_sum(image):
    color_sum = 0
    color_weight = (2, 1, 4)
    image = image.crop((0, 0, image.size[0], int(image.size[1]*0.0306)))
    image = image.convert('RGBA')
    im_slice = []
    im_slice.append(image.crop((0, 0, int(image.size[0] / 3), image.size[1])))
    im_slice.append(image.crop((int(image.size[0] / 3), 0, int(image.size[0] / 3 * 2), image.size[1])))
    im_slice.append(image.crop((int(image.size[0] / 3 * 2), 0, image.size[0], image.size[1])))
    # im_slice = tuple(image.crop((0, 0, int(image.size[0] / 3), image.size[1])), image.crop((int(image.size[0] / 3), 0, int(image.size[0] / 3 * 2), image.size[1])), image.crop((int(image.size[0] / 3 * 2), 0, image.size[0], image.size[1])))

    for i, im in enumerate(im_slice):
        for w in range(0, im.size[0]):
            for h in range(0, im.size[1]):
                color_sum += color_weight[i] * calc_pixel_var(im.getpixel((w, h)))

    return color_sum

def get_dominant_color(image):

    s = image.size
    image = image.crop((0, 0, s[0], int(s[1]*0.0306)))
#颜色模式转换，以便输出rgb颜色值
    image = image.convert('RGBA')

#生成缩略图，减少计算量，减小cpu压力
    # image.thumbnail((200, 200))

    max_score = 0
    dominant_color = 0

    for count, (r, g, b, a) in image.getcolors(image.size[0] * image.size[1]):
        # 跳过纯黑色
        if a == 0:
            continue

        saturation = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)[1]

        y = min(abs(r * 2104 + g * 4130 + b * 802 + 4096 + 131072) >> 13, 235)

        y = (y - 16.0) / (235 - 16)

        # 忽略高亮色
        # if y > 0.9:
            # continue
        # if ((r>200)&(g>200)&(b>200)):
            # continue

        # Calculate the score, preferring highly saturated colors.
        # Add 0.1 to the saturation so we don't completely ignore grayscale
        # colors by multiplying the count by zero, but still give them a low
        # weight.
        score = (saturation + 0.1) * count

        if score > max_score:
            max_score = score
            dominant_color = (r, g, b)
            # hex_color = hex(r)[2:] + hex(g)[2:] + hex(b)[2:]
            hex_color = '{:02x}{:02x}{:02x}'.format(r, g, b)

    return hex_color;

if __name__ == '__main__':
    im = Image.open(sys.argv[1])
    # print(get_dominant_color(im))
    res = calc_color_sum(im)
    if res >= 0:
        print('000000')
    else:
        print('ffffff')
