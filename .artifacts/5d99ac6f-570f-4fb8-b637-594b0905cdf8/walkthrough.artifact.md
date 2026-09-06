# خلاصه پیاده‌سازی پروژه آبوهوا (Weather SSD/SPARC)

## فاز اصلی (کامل ✅)
طبق چکلیست `AGENTS.md` و روش SSD/SPARC:
- مدل داده، سرویس ذخیره محلی (Offline Fallback)، سرویس API ساده، مدیریت وضعیت بومی (ChangeNotifier) و UI مینیمال مدرن
- قابلیت جستجوی شهر با Geocoding API رایگان Open-Meteo

## قابلیت جدید: اجرای تمامصفحه (Edge-to-Edge) روی همه گوشیها ✅
به درخواست کاربر، اپلیکیشن حالا در حالت تمامصفحه اجرا میشود — یعنی پسزمینه (گرادیان) پشت نوار وضعیت (Status Bar) و نوار ناوبری (Navigation Bar) کشیده میشود و نوارها شفافاند.

### تغییرات انجامشده
| فایل | تغییر |
|---|---|
| [main.dart](file:///Users/reza/Documents/fluterProject/weather_db_api_spare/lib/main.dart) | افزودن `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` + شفافسازی نوار وضعیت/ناوبری با آیکونهای روشن — روی همه نسخههای اندروید و iOS کار میکند |
| [weather_page.dart](file:///Users/reza/Documents/fluterProject/weather_db_api_spare/lib/pages/weather_page.dart) | حذف `SafeArea` از سطح خارجی؛ گرادیان/پسزمینه حالا **تمام صفحه** را میپوشاند و `SafeArea` به داخل گرادیان منتقل شد تا محتوا از زیر نوارهای سیستم بیرون نزند |
| [city_search_page.dart](file:///Users/reza/Documents/fluterProject/weather_db_api_spare/lib/pages/city_search_page.dart) | افزودن `SafeArea` (پایین) تا لیست نتایج پشت نوار ناوبری پنهان نشود |
| [launch_background.xml](file:///Users/reza/Documents/fluterProject/weather_db_api_spare/android/app/src/main/res/drawable/launch_background.xml) (drawable و drawable-v21) | اسپلش شروع با رنگ سرمهای تیره (`#0B1D33`) بهجای سفید — حذف فلش سفید هنگام شروع |

> [!NOTE]
> در Android 15+ (targetSdk 35) حالت Edge-to-Edge بهصورت پیشفرض اعمال میشود؛ این تغییرات باعث میشود در **همه نسخههای اندروید و iOS** رفتار یکسان و تمامصفحه باشد.

## صحتسنجی
| بررسی | نتیجه |
|---|---|
| `flutter analyze` | ✅ No issues found |
| `flutter build web --release` | ✅ موفق |