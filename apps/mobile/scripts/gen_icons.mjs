import { writeFileSync } from 'fs';
import { deflateSync } from 'zlib';

function createPNG(filename, width, height, pixelFn) {
  // Build raw image data (filter byte per row + RGB bytes)
  const rowSize = width * 3 + 1; // 1 filter byte + 3 bytes per pixel
  const raw = Buffer.alloc(rowSize * height);

  for (let y = 0; y < height; y++) {
    const rowOffset = y * rowSize;
    raw[rowOffset] = 0; // filter: None
    for (let x = 0; x < width; x++) {
      const [r, g, b] = pixelFn(x, y, width, height);
      const offset = rowOffset + 1 + x * 3;
      raw[offset] = r;
      raw[offset + 1] = g;
      raw[offset + 2] = b;
    }
  }

  const compressed = deflateSync(raw);

  // PNG chunks
  function chunk(type, data) {
    const len = Buffer.alloc(4);
    len.writeUInt32BE(data.length);
    const crcData = Buffer.concat([Buffer.from(type, 'ascii'), data]);
    let crc = 0xFFFFFFFF;
    for (let i = 0; i < crcData.length; i++) {
      crc ^= crcData[i];
      for (let j = 0; j < 8; j++) {
        crc = (crc >>> 1) ^ (crc & 1 ? 0xEDB88320 : 0);
      }
    }
    crc = (crc ^ 0xFFFFFFFF) >>> 0;
    const crcBuf = Buffer.alloc(4);
    crcBuf.writeUInt32BE(crc);
    return Buffer.concat([len, Buffer.from(type, 'ascii'), data, crcBuf]);
  }

  // IHDR
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8;  // bit depth
  ihdr[9] = 2;  // color type: RGB
  ihdr[10] = 0; // compression
  ihdr[11] = 0; // filter
  ihdr[12] = 0; // interlace

  const signature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
  const png = Buffer.concat([
    signature,
    chunk('IHDR', ihdr),
    chunk('IDAT', compressed),
    chunk('IEND', Buffer.alloc(0)),
  ]);

  writeFileSync(filename, png);
  console.log(`Created ${filename} (${width}x${height})`);
}

// Icon: shopping bag on dark navy
function iconPixel(x, y, w, h) {
  const bg = [15, 23, 42]; // #0F172A
  const fg = [96, 165, 250]; // blue-400

  const cx = w / 2;
  const cy = h / 2;
  const bagW = w * 0.55;
  const bagH = h * 0.55;
  const left = cx - bagW / 2;
  const right = cx + bagW / 2;
  const top = cy - bagH / 2;
  const bot = cy + bagH / 2;

  const hLeft = cx - bagW * 0.25;
  const hRight = cx + bagW * 0.25;
  const hTop = top - h * 0.08;

  const inBag = x >= left + 2 && x < right - 2 && y >= top && y < bot;
  const inHandle = x >= hLeft && x < hRight && y >= hTop && y < top - 2;

  return inBag || inHandle ? fg : bg;
}

// Splash: same bag centered on dark navy
function splashPixel(x, y, w, h) {
  const bg = [15, 23, 42];
  const fg = [96, 165, 250];

  const cx = w / 2;
  const cy = h / 2;
  const size = Math.min(w, h) * 0.3;
  const left = cx - size / 2;
  const right = cx + size / 2;
  const top = cy - size / 2;
  const bot = cy + size / 2;

  const hLeft = cx - size * 0.2;
  const hRight = cx + size * 0.2;
  const hTop = top - size * 0.08;

  const inBag = x >= left + 2 && x < right - 2 && y >= top + size * 0.15 && y < bot;
  const inHandle = x >= hLeft && x < hRight && y >= hTop && y < top + size * 0.15 - 2;

  return inBag || inHandle ? fg : bg;
}

// Generate all assets
const assetsDir = 'C:\\projects\\vendi\\apps\\mobile\\assets';

createPNG(`${assetsDir}\\icon.png`, 512, 512, iconPixel);
createPNG(`${assetsDir}\\adaptive-icon.png`, 256, 256, iconPixel);
createPNG(`${assetsDir}\\favicon.png`, 128, 128, iconPixel);
createPNG(`${assetsDir}\\splash.png`, 1284, 2778, splashPixel);

console.log('All assets generated!');
