# Safar — iOS-приложение для App Store

Нативная iOS-оболочка (Capacitor 8 + WKWebView) для веб-приложения
`https://200-96-110-14.sslip.io`. Сервер и само приложение не изменяются — iOS-приложение
просто открывает его внутри себя.

Уже настроено:

- Название **Safar**, Bundle ID `com.safar.app` (можно поменять)
- Иконка 1024×1024 и сплэш-экран из вашего логотипа
- Только iPhone, только портретная ориентация
- Русский язык по умолчанию
- Экран «Нет подключения», если интернета нет
- Разрешение на геолокацию (для времени намаза / киблы)
- `ITSAppUsesNonExemptEncryption = NO` — не нужно отвечать на вопрос про шифрование

## Без чего не обойтись

Подписанный IPA для App Store может собрать **только macOS с Xcode** и **только с вашим
аккаунтом Apple Developer** (99 $ в год, https://developer.apple.com/programs/).
Подписать приложение чужим аккаунтом нельзя.

---

## Вариант А — без Mac, через GitHub Actions (бесплатно)

1. **Apple Developer**: войдите на https://developer.apple.com/account → Membership →
   скопируйте **Team ID** (10 символов).
2. **App Store Connect** → https://appstoreconnect.apple.com → «Приложения» → «+» →
   «Новое приложение»: платформа iOS, имя `Safar`, язык русский, Bundle ID `com.safar.app`
   (если его нет в списке, создайте его в Developer → Identifiers → «+» → App IDs).
3. **API-ключ**: App Store Connect → «Пользователи и доступ» → «Интеграции» →
   «App Store Connect API» → «+» → роль **Admin** → скачайте файл `AuthKey_XXXX.p8`
   (скачать можно только один раз). Запишите **Key ID** и **Issuer ID**.
4. Создайте **приватный** репозиторий на GitHub и загрузите туда содержимое этой папки.
5. В репозитории: Settings → Secrets and variables → Actions → New repository secret:

   | Имя секрета | Значение |
   | --- | --- |
   | `APPLE_TEAM_ID` | Team ID из шага 1 |
   | `APP_STORE_CONNECT_KEY_ID` | Key ID из шага 3 |
   | `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID из шага 3 |
   | `APP_STORE_CONNECT_KEY_P8` | всё содержимое файла `.p8` (вместе со строками BEGIN/END) |

   Если хотите другой Bundle ID — вкладка Variables → `BUNDLE_ID`.
6. Actions → **Build iOS IPA** → Run workflow.

Через ~10 минут:

- готовый **IPA** лежит в разделе Artifacts этой сборки;
- он же автоматически загружен в App Store Connect → TestFlight.

## Вариант Б — на Mac с Xcode

```bash
npm ci
npx cap open ios      # в Xcode: Signing & Capabilities → выберите свою Team
TEAM_ID=XXXXXXXXXX ./build-ipa-mac.sh
```

IPA появится в `build/ipa/Safar.ipa`. Загрузить в App Store можно через приложение
**Transporter** (Mac App Store) или в Xcode → Product → Archive → Distribute App.

---

## Публикация после загрузки

В App Store Connect заполните: описание, ключевые слова, **скриншоты iPhone 6.9"**
(1320×2868), ссылку на **политику конфиденциальности** (обязательно), раздел
«Конфиденциальность приложения», возрастной рейтинг. Затем выберите сборку и нажмите
«Отправить на проверку».

## Важно про проверку Apple (Guideline 4.2)

Apple иногда отклоняет приложения, которые являются «просто сайтом в оболочке».
Чтобы пройти проверку:

- в описании для проверяющего укажите, что это полноценное приложение (азкары, дуа,
  намаз, Коран, аудио), а не рекламный сайт;
- в приложении не должно быть ссылок «скачайте на сайте», внешних оплат и т. п.;
- если отклонят — следующим шагом добавляются нативные функции (локальные уведомления о
  намазе, офлайн-режим), это делается в этом же проекте.

Также рекомендуется вместо `200-96-110-14.sslip.io` использовать собственный домен:
поменяйте адрес в `capacitor.config.json` (`server.url` и `allowNavigation`) и в
`www/index.html`.
