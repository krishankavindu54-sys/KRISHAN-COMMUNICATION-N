const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

// Minimal pure-JS PNG generator
function createPng(width, height, colorFn) {
    const rowBytes = width * 4 + 1;
    const rawData = Buffer.alloc(rowBytes * height);

    for (let y = 0; y < height; y++) {
        const rowOffset = y * rowBytes;
        rawData[rowOffset] = 0; // Filter byte 0 (None)
        for (let x = 0; x < width; x++) {
            const [r, g, b, a] = colorFn(x / width, y / height, x, y);
            const pxOffset = rowOffset + 1 + x * 4;
            rawData[pxOffset] = r;
            rawData[pxOffset + 1] = g;
            rawData[pxOffset + 2] = b;
            rawData[pxOffset + 3] = a;
        }
    }

    const compressed = zlib.deflateSync(rawData);

    // PNG Header
    const signature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);

    // IHDR Chunk
    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(width, 0);
    ihdr.writeUInt32BE(height, 4);
    ihdr[8] = 8; // Bit depth
    ihdr[9] = 6; // RGBA
    ihdr[10] = 0; // Compression
    ihdr[11] = 0; // Filter
    ihdr[12] = 0; // Interlace
    const ihdrChunk = makeChunk('IHDR', ihdr);

    // IDAT Chunk
    const idatChunk = makeChunk('IDAT', compressed);

    // IEND Chunk
    const iendChunk = makeChunk('IEND', Buffer.alloc(0));

    return Buffer.concat([signature, ihdrChunk, idatChunk, iendChunk]);
}

function makeChunk(type, data) {
    const len = data.length;
    const buf = Buffer.alloc(8 + len + 4);
    buf.writeUInt32BE(len, 0);
    buf.write(type, 4, 4, 'ascii');
    data.copy(buf, 8);
    const crc = crc32(buf.subarray(4, 8 + len));
    buf.writeUInt32BE(crc >>> 0, 8 + len);
    return buf;
}

// Standard CRC32 for PNG chunks
function crc32(buf) {
    let crc = 0 ^ (-1);
    for (let i = 0; i < buf.length; i++) {
        crc = (crc >>> 8) ^ crcTable[(crc ^ buf[i]) & 0xFF];
    }
    return (crc ^ (-1)) >>> 0;
}

const crcTable = new Uint32Array(256);
for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) {
        c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
    }
    crcTable[n] = c;
}

// Generate Beautiful Modern Gradient Icon
function posIconColor(u, v, x, y, size) {
    // Distance from center for rounded squircle
    const cx = size / 2;
    const cy = size / 2;
    const dx = Math.abs(x - cx);
    const dy = Math.abs(y - cy);
    const radius = size * 0.44;
    const cornerRadius = size * 0.22;

    // Squircle distance formula
    const qx = Math.max(0, dx - (radius - cornerRadius));
    const qy = Math.max(0, dy - (radius - cornerRadius));
    const distCorner = Math.sqrt(qx * qx + qy * qy);

    if (distCorner > cornerRadius) {
        return [0, 0, 0, 0]; // Transparent outside
    }

    // Gradient Background (Indigo -> Violet -> Blue)
    const r = Math.floor(79 + u * 40 - v * 20);
    const g = Math.floor(70 - u * 20 + v * 30);
    const b = Math.floor(229 + u * 20 - v * 20);

    // Inner Card / POS Register icon area
    const inCardX = u >= 0.22 && u <= 0.78;
    const inCardY = v >= 0.25 && v <= 0.75;

    if (inCardX && inCardY) {
        // White / Silver Register body
        const innerU = (u - 0.22) / 0.56;
        const innerV = (v - 0.25) / 0.50;

        // Screen area
        if (innerU >= 0.15 && innerU <= 0.85 && innerV >= 0.15 && innerV <= 0.55) {
            // Dark Screen
            if (innerV >= 0.28 && innerV <= 0.42 && innerU >= 0.25 && innerU <= 0.75) {
                // Emerald price text simulation
                return [16, 185, 129, 255];
            }
            return [15, 23, 42, 255]; // Slate 900
        }

        // Cash Drawer bottom
        if (innerV >= 0.65) {
            if (innerU >= 0.75 && innerU <= 0.85 && innerV >= 0.75 && innerV <= 0.85) {
                return [245, 158, 11, 255]; // Gold lock
            }
            return [241, 245, 249, 255];
        }

        return [255, 255, 255, 255];
    }

    // Star sparkle top right
    const sDist = Math.hypot(x - size * 0.78, y - size * 0.22);
    if (sDist < size * 0.04) {
        return [251, 191, 36, 255];
    }

    return [Math.min(255, r), Math.min(255, g), Math.min(255, b), 255];
}

// ICO Builder (Embedding 64x64 PNG inside .ico)
function createIco(pngBuffer, width = 64, height = 64) {
    const header = Buffer.alloc(6);
    header.writeUInt16LE(0, 0); // Reserved
    header.writeUInt16LE(1, 2); // Type 1 = ICO
    header.writeUInt16LE(1, 4); // 1 Image

    const entry = Buffer.alloc(16);
    entry.writeUInt8(width >= 256 ? 0 : width, 0);
    entry.writeUInt8(height >= 256 ? 0 : height, 1);
    entry.writeUInt8(0, 2); // Palette
    entry.writeUInt8(0, 3); // Reserved
    entry.writeUInt16LE(1, 4); // Color planes
    entry.writeUInt16LE(32, 6); // Bits per pixel
    entry.writeUInt32LE(pngBuffer.length, 8); // Size
    entry.writeUInt32LE(22, 12); // Offset (6 + 16 = 22)

    return Buffer.concat([header, entry, pngBuffer]);
}

const iconsDir = path.join(__dirname, 'assets', 'icons');
if (!fs.existsSync(iconsDir)) {
    fs.mkdirSync(iconsDir, { recursive: true });
}

console.log('Generating App Icons...');

// 1. 192x192 PNG
const png192 = createPng(192, 192, (u, v, x, y) => posIconColor(u, v, x, y, 192));
fs.writeFileSync(path.join(iconsDir, 'icon-192.png'), png192);
console.log('✔ Generated icon-192.png');

// 2. 512x512 PNG
const png512 = createPng(512, 512, (u, v, x, y) => posIconColor(u, v, x, y, 512));
fs.writeFileSync(path.join(iconsDir, 'icon-512.png'), png512);
console.log('✔ Generated icon-512.png');

// 3. 64x64 ICO for Windows
const png64 = createPng(64, 64, (u, v, x, y) => posIconColor(u, v, x, y, 64));
const ico = createIco(png64, 64, 64);
fs.writeFileSync(path.join(iconsDir, 'app-icon.ico'), ico);
fs.writeFileSync(path.join(__dirname, 'favicon.ico'), ico);
console.log('✔ Generated app-icon.ico & favicon.ico');

console.log('✨ All icons generated successfully!');
