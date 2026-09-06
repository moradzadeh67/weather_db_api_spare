# چک‌لیست کارهای پروژه آب‌وهوا (Weather SSD/SPARC Task Tracker)

## فاز اصلی (کامل شد ✅)
- `[x]` ۱. آماده‌سازی ساختار پوشه‌ها و مدل داده (Model)
- `[x]` ۲. پیاده‌سازی سرویس ذخیره محلی (Storage Service)
- `[x]` ۳. پیاده‌سازی سرویس API (API Service)
- `[x]` ۴. پیاده‌سازی مدیریت وضعیت بومی (State/ChangeNotifier)
- `[x]` ۵. پیاده‌سازی رابط کاربری مینیمال و زیبا (UI Page)
- `[x]` ۶. اتصال به main.dart و تست نهایی

## قابلیت جدید: جستجوی شهر (کامل شد ✅)
- `[x]` ایجاد مدل شهر (CityModel)
- `[x]` افزودن متد searchCities به سرویس API (Geocoding API رایگان)
- `[x]` افزودن ذخیره/بازیابی شهر انتخابی در Storage Service
- `[x]` افزودن state جستجو و selectCity به WeatherNotifier
- `[x]` ساخت صفحه جستجوی شهر (CitySearchPage) با Debounce
- `[x]` افزودن دکمه جستجو به صفحه اصلی و اتصال ناوبری
- `[x]` flutter analyze ✅ | flutter build web ✅