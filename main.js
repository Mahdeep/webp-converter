const { app, BrowserWindow, ipcMain, dialog } = require('electron');
const path = require('path');
const sharp = require('sharp');
const fs = require('fs').promises;

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 900,
    height: 700,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    icon: path.join(__dirname, 'icon.png')
  });

  mainWindow.loadFile('index.html');
  
  // برای دیباگ - حذف کنید در نسخه نهایی
  // mainWindow.webContents.openDevTools();
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// انتخاب فایل‌های تصویری
ipcMain.handle('select-files', async () => {
  const result = await dialog.showOpenDialog(mainWindow, {
    properties: ['openFile', 'multiSelections'],
    filters: [
      { name: 'Images', extensions: ['jpg', 'jpeg', 'png', 'bmp', 'tiff', 'gif', 'webp'] }
    ]
  });
  
  return result.filePaths;
});

// انتخاب پوشه خروجی
ipcMain.handle('select-output-folder', async () => {
  const result = await dialog.showOpenDialog(mainWindow, {
    properties: ['openDirectory']
  });
  
  return result.filePaths[0];
});

// تبدیل تصاویر به WebP
ipcMain.handle('convert-images', async (event, { files, outputFolder, quality }) => {
  const results = [];
  
  for (let i = 0; i < files.length; i++) {
    const inputPath = files[i];
    const fileName = path.basename(inputPath, path.extname(inputPath));
    const outputPath = path.join(outputFolder, `${fileName}.webp`);
    
    try {
      // تبدیل واقعی تصویر به WebP
      await sharp(inputPath)
        .webp({ quality: parseInt(quality) })
        .toFile(outputPath);
      
      const inputStats = await fs.stat(inputPath);
      const outputStats = await fs.stat(outputPath);
      
      results.push({
        success: true,
        inputFile: path.basename(inputPath),
        outputFile: path.basename(outputPath),
        originalSize: inputStats.size,
        newSize: outputStats.size,
        reduction: ((1 - outputStats.size / inputStats.size) * 100).toFixed(1)
      });
      
      // ارسال پیشرفت
      event.sender.send('conversion-progress', {
        current: i + 1,
        total: files.length,
        fileName: path.basename(inputPath)
      });
      
    } catch (error) {
      results.push({
        success: false,
        inputFile: path.basename(inputPath),
        error: error.message
      });
    }
  }
  
  return results;
});
