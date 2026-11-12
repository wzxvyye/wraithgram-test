# Wraithgram — тестовая сборка IPA

Мини-приложение на SwiftUI. Нужно только для того, чтобы проверить всю цепочку:
**код → GitHub Actions (macOS) → `.ipa` → Sideloadly/AltStore → iPhone**.
Никакого Xcode-проекта здесь нет: `.app` собирается `swiftc`, как это делают
сайдлоад-проекты, и пакуется в `.ipa` вручную.

Что видно на экране после запуска: призрак 👻, надпись **Wraithgram**, версия,
версия iOS и модель устройства.

---

## 1. Что уже готово в папке

```text
wraithgram-test/
├─ App/
│  ├─ Sources/App.swift          — сам код приложения
│  ├─ Info.plist                 — описание бандла (имя, bundle id, min iOS 16)
│  └─ Icon/*.png                 — иконки, нарезанные из tools/wraithgram-icon.png
├─ scripts/
│  ├─ build_ipa.sh               — компиляция + упаковка в .ipa (запускается на macOS)
│  └─ make_icons.py              — пересобрать иконки из 1024×1024 (Windows/macOS)
└─ .github/workflows/build-ipa.yml — сборка на macOS-раннере GitHub
```

Пересобрать иконки (если поменяешь картинку):

```powershell
python scripts\make_icons.py "D:\путь\к\иконке-1024.png"
```

---

## 2. Как получить `.ipa`

1. Создать на GitHub **публичный** пустой репозиторий (например `wraithgram-test`).
2. Загрузить в него содержимое этой папки (не саму папку, а её содержимое — `.github` тоже).
3. Вкладка **Actions** → workflow **Build IPA** → **Run workflow**.
4. Через ~2 минуты: **Artifacts → WraithgramTest-ipa** → скачать zip → внутри `WraithgramTest.ipa`.

Сборка идёт на `macos-latest`, бесплатно для публичных репозиториев.

---

## 3. Установка на iPhone (без Mac)

### Sideloadly (быстрее)

1. Установить [Sideloadly](https://sideloadly.io) на Windows.
2. Установить iTunes (или Apple Devices) с сайта Apple — нужен для драйверов устройства.
3. Подключить iPhone кабелем, нажать «Доверять».
4. Перетащить `WraithgramTest.ipa` в Sideloadly, ввести свой Apple ID.
5. Нажать **Start**. Sideloadly подпишет приложение и установит его.
6. На iPhone: **Настройки → Основные → VPN и управление устройством** → довериться профилю
   разработчика.

### AltStore

1. Установить AltServer на Windows, AltStore — на iPhone.
2. AltStore: **My Apps → +** → выбрать `.ipa`.
3. Ввести Apple ID, дождаться установки.
4. AltStore переподписывает приложение автоматически, пока AltServer запущен
   на компьютере в той же сети.

### Ограничения бесплатного Apple ID

- Подпись живёт **7 дней**, потом приложение перестаёт запускаться → переподписать.
- Максимум 3 приложения и 10 App ID в неделю.
- Платный Apple Developer Program ($99/год) снимает эти ограничения (подпись 1 год).

---

## 4. Если сборка упала

Смотреть лог шага **Build unsigned IPA** в Actions. Частые причины:

| Ошибка | Причина |
| --- | --- |
| `xcrun: error: unable to find utility "swiftc"` | на раннере нет Xcode — проверить, что `runs-on: macos-latest` |
| `error: unable to open ... Info.plist` | файлы загружены в подпапку вместо корня репозитория |
| `Artifact not found` | сборка упала раньше; смотреть её лог |

---

## 5. Что дальше

Если тест прошёл — это же workflow переносится на настоящий проект Wraithgram
(форк Ghostgram/Telegram-iOS), но там сборка идёт через Bazel и занимает 1–3 часа.
