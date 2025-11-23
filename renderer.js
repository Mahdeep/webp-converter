let selectedFiles = [];
let outputFolder = '';

// عناصر DOM
const selectFilesBtn = document.getElementById('selectFilesBtn');
const selectOutputBtn = document.getElementById('selectOutputBtn');
const convertBtn = document.getElementById('convertBtn');
const qualitySlider = document.getElementById('qualitySlider');
const qualityValue = document.getElementById('qualityValue');
const selectedFilesInfo = document.getElementById('selectedFilesInfo');
const outputFolderInfo = document.getElementById('outputFolderInfo');
const progressSection = document.getElementById('progressSection');
const resultsSection = document.getElementById('resultsSection');
const progressFill = document.getElementById('progressFill');
const progressText = document.getElementById('progressText');
const currentFile = document.getElementById('currentFile');
const resultsList = document.getElementById('resultsList');
const summaryStats = document.getElementById('summaryStats');

// به‌روزرسانی نمایش کیفیت
qualitySlider.addEventListener('input', (e) => {
  qualityValue.textContent = e.target.value;
});

// انتخاب فایل‌ها
selectFilesBtn.addEventListener('click', async () => {
  const files = await window.electronAPI.selectFiles();
  if (files && files.length > 0) {
    selectedFiles = files;
    selectedFilesInfo.textContent = `${files.length} فایل انتخاب شده`;
    selectedFilesInfo.style.color = '#11998e';
    checkReadyToConvert();
  }
});

// انتخاب پوشه خروجی
selectOutputBtn.addEventListener('click', async () => {
  const folder = await window.electronAPI.selectOutputFolder();
  if (folder) {
    outputFolder = folder;
    outputFolderInfo.textContent = folder;
    outputFolderInfo.style.color = '#11998e';
    checkReadyToConvert();
  }
});

// بررسی آماده بودن برای تبدیل
function checkReadyToConvert() {
  if (selectedFiles.length > 0 && outputFolder) {
    convertBtn.disabled = false;
  }
}

// شروع تبدیل
convertBtn.addEventListener('click', async () => {
  // پاک کردن نتایج قبلی
  resultsSection.style.display = 'none';
  resultsList.innerHTML = '';
  summaryStats.innerHTML = '';
  
  // نمایش پیشرفت
  progressSection.style.display = 'block';
  convertBtn.disabled = true;
  selectFilesBtn.disabled = true;
  selectOutputBtn.disabled = true;
  
  const quality = qualitySlider.value;
  
  // دریافت پیشرفت
  window.electronAPI.onConversionProgress((progress) => {
    const percent = Math.round((progress.current / progress.total) * 100);
    progressFill.style.width = `${percent}%`;
    progressText.textContent = `در حال پردازش... ${progress.current} از ${progress.total}`;
    currentFile.textContent = `فایل جاری: ${progress.fileName}`;
  });
  
  // شروع تبدیل
  const results = await window.electronAPI.convertImages({
    files: selectedFiles,
    outputFolder: outputFolder,
    quality: quality
  });
  
  // نمایش نتایج
  displayResults(results);
  
  // فعال کردن دوباره دکمه‌ها
  progressSection.style.display = 'none';
  convertBtn.disabled = false;
  selectFilesBtn.disabled = false;
  selectOutputBtn.disabled = false;
});

// نمایش نتایج
function displayResults(results) {
  resultsSection.style.display = 'block';
  
  let successCount = 0;
  let totalOriginalSize = 0;
  let totalNewSize = 0;
  
  results.forEach(result => {
    const resultItem = document.createElement('div');
    resultItem.className = `result-item ${result.success ? 'success' : 'error'}`;
    
    if (result.success) {
      successCount++;
      totalOriginalSize += result.originalSize;
      totalNewSize += result.newSize;
      
      resultItem.innerHTML = `
        <div class="result-item-header">
          <span class="result-filename">✅ ${result.inputFile}</span>
          <span class="result-status success">موفق</span>
        </div>
        <div class="result-details">
          حجم قبل: ${formatBytes(result.originalSize)} → 
          حجم بعد: ${formatBytes(result.newSize)} 
          (کاهش ${result.reduction}%)
        </div>
      `;
    } else {
      resultItem.innerHTML = `
        <div class="result-item-header">
          <span class="result-filename">❌ ${result.inputFile}</span>
          <span class="result-status error">خطا</span>
        </div>
        <div class="result-error">${result.error}</div>
      `;
    }
    
    resultsList.appendChild(resultItem);
  });
  
  // نمایش آمار کلی
  const totalReduction = totalOriginalSize > 0 
    ? ((1 - totalNewSize / totalOriginalSize) * 100).toFixed(1)
    : 0;
  
  summaryStats.innerHTML = `
    <h3>📊 خلاصه نتایج</h3>
    <div class="stats-grid">
      <div class="stat-item">
        <span class="stat-value">${successCount}/${results.length}</span>
        <span class="stat-label">تبدیل موفق</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">${formatBytes(totalOriginalSize)}</span>
        <span class="stat-label">حجم کل قبل</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">${formatBytes(totalNewSize)}</span>
        <span class="stat-label">حجم کل بعد</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">${totalReduction}%</span>
        <span class="stat-label">کاهش کل حجم</span>
      </div>
    </div>
  `;
}

// فرمت کردن حجم فایل
function formatBytes(bytes) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}
