const { createCanvas } = require('canvas');
const fs = require('fs');
const path = require('path');

// ساخت یک آیکون ساده برای برنامه
function createIcon() {
  const canvas = createCanvas(256, 256);
  const ctx = canvas.getContext('2d');

  // پس‌زمینه گرادیانت آبی به سبز
  const gradient = ctx.createLinearGradient(0, 0, 256, 256);
  gradient.addColorStop(0, '#4158D0');
  gradient.addColorStop(0.5, '#C850C0');
  gradient.addColorStop(1, '#FFCC70');
  
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, 256, 256);

  // متن WebP
  ctx.fillStyle = 'white';
  ctx.font = 'bold 60px Arial';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText('WebP', 128, 128);

  return canvas;
}

// ذخیره به عنوان PNG
const canvas = createIcon();
const buffer = canvas.toBuffer('image/png');
fs.writeFileSync(path.join(__dirname, 'icon.png'), buffer);

console.log('✅ آیکون icon.png ساخته شد');
console.log('⚠️ برای ساخت icon.ico، از یک ابزار آنلاین مثل https://convertio.co/png-ico/ استفاده کنید');
console.log('یا از ابزار ImageMagick استفاده کنید: magick convert icon.png -define icon:auto-resize=256,128,96,64,48,32,16 icon.ico');
