# 🏪 Krishan Communication & Studio - Point of Sale (POS) System

පරිගණක (PC), ලැප්ටොප් (Laptop), සහ ස්මාර්ට් ජංගම දුරකථන (Smartphones / Tablets) එකම Wi-Fi ජාලය තුළ සම්බන්ධ කර තථ්‍ය කාලීනව (Real-time Live Sync) බිල්පත් සහ තොග කළමනාකරණය කළ හැකි නවීන POS පද්ධතියකි.

---

## 🔑 Default Login Credentials (මුරපද)

| Role (තනතුර) | Username | Password | Quick QR Login |
| :--- | :--- | :--- | :--- |
| **Cashier (කැෂියර්)** | `cashier` | `cashier123` | ⚡ Instant 1-Tap Login (මුරපද අවශ්‍ය නැත) |
| **Administrator (හිමිකරු)** | `admin` | `admin123` | 🛡️ Full Admin Access |

---

## 🚀 ආරම්භ කරගන්නා ආකාරය (Quick Start Guide)

### 1. Main PC එකෙහි POS එක ක්‍රියාත්මක කිරීම:
- ෆෝල්ඩරයේ ඇති **`Start-POS.bat`** ගොනුව Double-Click කරන්න.
- එවිට Server එක ක්‍රියාත්මක වන අතර Command Prompt තිරයේ Wi-Fi QR Code එකක් දිස්වනු ඇත.
- ස්වයංක්‍රීයව පරිගණකයේ POS Desktop Window එක විවෘත වේ.

### 2. Wi-Fi හරහා Phone / Tablet සම්බන්ධ කරගැනීම (Mobile QR Login):
1. **පළමු වරට පමණක්:** ෆෝල්ඩරයේ ඇති **`Setup-WiFi-And-Firewall.bat`** ගොනුව Double-Click කර Windows Firewall සඳහා අවසර දෙන්න.
2. ඔබගේ Phone එක හෝ Tablet එක Main PC එක සම්බන්ධ කර ඇති **Wi-Fi ජාලයටම** සම්බන්ධ කරන්න.
3. ක්‍රම දෙකකින් Phone එකෙන් සම්බන්ධ විය හැක:
   - **ක්‍රමය 1:** POS System එකේ ඉහළ Navbar එකේ ඇති **"📱 Phone QR"** බටන් එක ඔබන්න. තිරයේ දිස්වන QR Code එක Phone Camera එකෙන් Scan කරන්න.
   - **ක්‍රමය 2:** `Start-POS.bat` ක්‍රියාත්මක වන විට Command Prompt තිරයේ දිස්වන QR Code එක Phone Camera එකෙන් Scan කරන්න.
4. කිසිදු Username හෝ Password එකක් Type නොකර කෙලින්ම **Cashier** ලෙස POS System එක Phone එක මත විවෘත වේ!
5. Phone එකේ Chrome හෝ Safari Menu එකෙන් **"Add to Home Screen"** හෝ **"Install App"** ලබා දුන් විට එය සාමාන්‍ය Android/iOS App එකක් මෙන් Touch Billing සඳහා භාවිතා කළ හැක.

### 3. තථ්‍ය කාලීන සමමුහූර්තකරණය (Real-time Live Sync):
- Phone එකෙන් හෝ PC එකෙන් බිලක් නිකුත් කළ සැනින් අනෙක් සියලුම Devices වල තොග (Stock), විකුණුම් (Sales) සහ උපකරණ පුවරුව (Dashboard) කිසිදු Refresh කිරීමකින් තොරව ක්ෂණිකව Live Update වේ.
- නව බිලක් නිකුත් වූ විට ශ්‍රව්‍ය නාදයක් (Audio Chime) සහ Notification එකක් මඟින් දැනුම් දෙනු ලැබේ.

---

## 📁 පිරිසිදු කරන ලද ගොනු ව්‍යුහය (Clean Project Structure)

```
f:\pos\
├── Start-POS.bat                 # 1-Click Server & Desktop POS Launcher
├── Setup-WiFi-And-Firewall.bat   # 1-Click Wi-Fi Firewall & Network Access Setup
├── Install-Krishan-POS.bat       # 1-Click Desktop Shortcut & Library Installer
├── Run-Krishan-POS.vbs           # Background Silent Desktop Runner
├── Update-POS.bat                # 1-Click System Updater
│
├── server.js                     # Express.js API, Socket.io Realtime Sync & QR Generator
├── database.js                   # High-Performance Built-in SQLite Database Engine
├── index.html                    # Main POS Billing Interface & Touch UI
├── login.html                    # 1-Tap Quick Authentication with QR parameters
├── app.js                        # Frontend Application Engine, IndexedDB & Sync Client
│
├── assets/
│   ├── js/qrcode.min.js          # 100% Offline Standalone QR Code Engine
│   └── icons/                    # App PWA & Desktop Icons
│
├── data/
│   └── pos.sqlite                # Local SQLite Database
├── package.json                  # Dependencies (Express, Socket.io, QRCode, Bcrypt)
└── README.md                     # Documentation
```

---

## 🛠️ English Summary: Features & Usage

1. **Clean Workspace**: All unnecessary temporary zip archives, duplicated upload folders, and unused configurations have been removed.
2. **Wi-Fi QR Login**: Phones on the local Wi-Fi router scan the dynamic QR code to log in immediately as Cashier with zero manual typing.
3. **Instant Real-time Sync**: Built on WebSocket (`socket.io`), all connected devices synchronize sales, inventory, repairs, and debts live with audio feedback.
4. **100% Offline Capable**: Standalone QR code generation and IndexedDB Dexie caching allow seamless operation even without active internet connection.

---
&copy; 2026 Krishan Communication & Studio. All Rights Reserved.
