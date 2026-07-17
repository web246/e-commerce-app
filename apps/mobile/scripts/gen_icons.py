import struct, zlib, time, os

def create_png_fast(width, height, bg, fg, filename):
    """Generate a PNG with dark navy bg and blue bag shape"""
    raw = bytearray()
    cx, cy = width // 2, height // 2
    
    bag_scale = 0.55
    bag_w = int(width * bag_scale)
    bag_h = int(height * bag_scale)
    left = cx - bag_w // 2
    right = cx + bag_w // 2
    top = cy - bag_h // 2
    bot = cy + bag_h // 2
    h_left = cx - int(bag_w * 0.45)
    h_right = cx + int(bag_w * 0.45)
    handle_h = int(height * 0.08)
    handle_top = top - handle_h
    handle_bot = top - 2
    
    for y in range(height):
        raw.append(0)  # filter byte
        for x in range(width):
            in_bag = left + 2 <= x < right - 2 and top <= y < bot
            in_handle = h_left <= x < h_right and handle_top <= y < handle_bot
            r, g, b = fg if (in_bag or in_handle) else bg
            raw.extend([r, g, b])
    
    compressed = zlib.compress(bytes(raw))
    
    def chunk(t, data):
        c = t + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xFFFFFFFF)
    
    header = b'\x89PNG\r\n\x1a\n'
    ihdr = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'wb') as f:
        f.write(header + chunk(b'IHDR', ihdr) + chunk(b'IDAT', compressed) + chunk(b'IEND', b''))
    print(f'Created {filename} ({width}x{height})')


bg = (15, 23, 42)   # #0F172A navy
fg = (96, 165, 250)  # blue-400

t = time.time()
assets = r'C:\projects\vendi\apps\mobile\assets'
create_png_fast(512, 512, bg, fg, os.path.join(assets, 'icon.png'))
create_png_fast(256, 256, bg, fg, os.path.join(assets, 'adaptive-icon.png'))
create_png_fast(128, 128, bg, fg, os.path.join(assets, 'favicon.png'))
# Splash: solid bg is enough since app.json has backgroundColor
create_png_fast(10, 10, bg, bg, os.path.join(assets, 'splash.png'))
print(f'Done in {time.time()-t:.1f}s')
