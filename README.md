# آشپزیار (Ashpazyar)

اپلیکیشن موبایل/وب فارسی (RTL) که بر اساس موادی که کاربر توی خونه‌اش داره ("قفسه")
و یک سطح بودجه‌ی اضافی، دستور پخت‌های واقعی و متنوع پیشنهاد می‌ده — با هدف کم‌کردن
هزینه و دورریز مواد غذایی.

## فلوی اصلی

ورود/ثبت‌نام → قفسه‌ی من (افزودن/حذف مواد) → انتخاب بودجه → صفحه‌ی بارگذاری →
پیشنهاد غذاها → جزئیات هر غذا (مواد لازم با مقدار، مراحل پخت، ارزش غذایی،
برچسب‌های گیاهی/وگان/بدون‌گلوتن).

## تکنولوژی

- **Flutter** (Dart) — کد اصلی اپ در [`lib/`](lib/)
- بک‌اند واقعی هنوز پیاده‌سازی نشده؛ `ApiClient` به‌صورت پیش‌فرض به
  `https://api.ashpazyar.ir` وصل می‌شه (که فعلاً وجود نداره). برای تست محلی می‌تونی
  یک بک‌اند سازگار با قرارداد زیر بسازی و آدرسش رو موقع اجرا override کنی:

  ```
  flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:9000
  ```

## اجرا

```bash
flutter pub get
flutter run -d chrome   # یا هر دستگاه دیگه‌ای که flutter devices نشون می‌ده
```

برای اجرای تست‌ها:

```bash
flutter test
```

## ساختار پروژه

```
lib/
  core/            تم، ویجت‌های مشترک، لایه‌ی شبکه
  features/
    auth/          ورود / ثبت‌نام
    pantry/        قفسه‌ی مواد غذایی
    recipes/       انتخاب بودجه، پیشنهاد غذا، جزئیات دستور پخت
```

## قرارداد API مورد انتظار بک‌اند

```
POST /auth/login      {identifier, password}          -> {token}
POST /auth/register   {name, identifier, password}     -> {token}
GET  /pantry/items                                     -> [{id, name}]
POST /pantry/items     {name}                           -> {id, name}
DELETE /pantry/items/{id}
GET  /ingredients/search?q=                            -> [{id, name}]
POST /recipes/suggest {pantryItems, budgetTier}         -> {recipes: [...]}
```

هر آیتم در `recipes` شامل: `id`, `title`, `desc`, `category`, `province`,
`prepTime`, `cookTime`, `servings`, `cost`, `difficulty`,
`ingredients` (لیست `{name, amount}`), `fromPantry`, `toBuy`, `steps`,
`nutrition` (`calories`/`protein`/`fat`/`carbs`), `isVegetarian`,
`isGlutenFree`, `isVegan`, `image`, `tags`.

## سند طراحی

فایل‌های handoff طراحی اولیه در [`_handoff/design_handoff_ashpazyar/`](_handoff/design_handoff_ashpazyar/)
نگه‌داری شده‌اند (پروتوتایپ HTML + توضیحات — صرفاً مرجع طراحی، نه کد پروداکشن).
