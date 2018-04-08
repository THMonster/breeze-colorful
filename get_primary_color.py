#!/usr/bin/python3
import colorsys, sys
from PIL import Image

def get_dominant_color(image):

#颜色模式转换，以便输出rgb颜色值
    image = image.convert('RGBA')

#生成缩略图，减少计算量，减小cpu压力
    image.thumbnail((200, 200))

    max_score = 0#原来的代码此处为None
    dominant_color = 0#原来的代码此处为None，但运行出错，改为0以后 运行成功，原因在于在下面的 >score > max_score的比较中，max_score的初始格式不定

    for count, (r, g, b, a) in image.getcolors(image.size[0] * image.size[1]):
        # 跳过纯黑色
        if a == 0:
            continue

        saturation = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)[1]

        y = min(abs(r * 2104 + g * 4130 + b * 802 + 4096 + 131072) >> 13, 235)

        y = (y - 16.0) / (235 - 16)

        # 忽略高亮色
        if y > 0.9:
            continue
        if ((r>200)&(g>200)&(b>200)):
            continue

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
    print(get_dominant_color(im))
