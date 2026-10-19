# دليل نشر وتشغيل جسر Evolution API على Render ومسح الـ QR Code

يشرح هذا الدليل كيفية نشر وتشغيل **Evolution API v2** (أقوى جسر غير رسمي لربط WhatsApp مع n8n والأنظمة البرمجية) كـ **Web Service** مجاني على منصة **Render**، مع ربطه بـ **Supabase PostgreSQL** لحفظ الجلسات وتفادي قطع الاتصال، واستخدام **Evolution Manager** لمسح الـ QR Code من المتصفح بسهولة.

---

## 1. تطبيق مخطط قاعدة البيانات في Supabase (SQL Schema)

قبل تشغيل البوتات، جهز جدول حفظ الحجوزات والطلبات:
1. افتح مشروعك في [Supabase Dashboard](https://supabase.com).
2. من القائمة الجانبية، ادخل إلى **SQL Editor**.
3. افتح ملف supabase_schema.sql الموجود في مجلد المشروع، وانسخ كل محتواه والصقه داخل محرر SQL في Supabase.
4. اضغط على زر **Run**.
5. ستلاحظ ظهور جدول ot_records تحت قسم **Table Editor** جاهزاً لاستقبال البيانات والحجوزات.

---

## 2. رفع التعديلات إلى GitHub

افتح الـ Terminal في مجلد المشروع ونفذ:
`ash
git add supabase_schema.sql evolution_api_deploy
git commit -m Add Supabase schema and Evolution API deployment files
git push origin main
`

---

## 3. نشر Evolution API على منصة Render

### الطريقة الأولى: النشر الآلي بطلبي منك
بما أن Render API مربوط بالفعل، يمكنك ببساطة أن تطلب مني لاحقاً:
> *قم بإنشاء خدمة Evolution API على رندر* وسأقوم بإنشائها لك بالكامل عبر الـ API!

### الطريقة الثانية: النشر اليدوي من لوحة تحكم Render
1. ادخل إلى [Render Dashboard](https://dashboard.render.com).
2. اضغط على **New +** ➔ **Web Service**.
3. اختر مستودع whatsapp-bot-factory واضغط **Connect**.
4. حدد الإعدادات التالية:
   - **Name**: evolution-whatsapp-bridge
   - **Region**: Frankfurt (نفس منطقة n8n وسوبابيز للسرعة).
   - **Root Directory**: evolution_api_deploy
   - **Environment**: Docker
   - **Plan**: Free
5. في قسم **Environment Variables**، أضف المتغيرات التالية:

| المتغير (Key) | القيمة (Value) |
| :--- | :--- |
| PORT | 8080 |
| SERVER_TYPE | http |
| SERVER_PORT | 8080 |
| SERVER_URL | https://<YOUR_EVOLUTION_SERVICE>.onrender.com |
| AUTHENTICATION_TYPE | pikey |
| AUTHENTICATION_API_KEY | MySuperSecretEvolutionKey2026 |
| AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES | 	rue |
| DATABASE_ENABLED | 	rue |
| DATABASE_PROVIDER | postgresql |
| DATABASE_CONNECTION_URI | postgresql://postgres.isuweqwtuwkzlxjvzhtd:/m4iX?ke-_-5@aws-0-eu-west-2.pooler.supabase.com:6543/postgres?sslmode=disable |
| DATABASE_CONNECTION_CLIENT_NAME | evolution_whatsapp_factory |
| DATABASE_SAVE_DATA_INSTANCE | 	rue |
| DATABASE_SAVE_DATA_NEW_MESSAGE | 	rue |
| DATABASE_SAVE_MESSAGE_UPDATE | 	rue |
| DATABASE_SAVE_DATA_CONTACTS | 	rue |
| DATABASE_SAVE_DATA_CHATS | 	rue |
| MANAGER_ENABLED | 	rue |
| MANAGER_PORT | 8080 |
| QRCODE_LIMIT | 30 |
| QRCODE_COLOR | #198754 |
| DEL_INSTANCE | alse |

6. اضغط على **Create Web Service**.

---

## 4. مسح الـ QR Code وربط رقم الواتساب

بفضل تفعيل **Evolution Manager** المدمج، لست بحاجة لكتابة أكواد برمجية لربط الرقم:

1. بعد اكتمال النشر وتحول حالة السيرفر إلى **Live**، افتح رابط الخدمة في المتصفح متبوعاً بـ /manager:
   `
   https://evolution-whatsapp-bridge.onrender.com/manager
   `
2. سيطلب منك النظام مفتاح الـ API:
   - أدخل: MySuperSecretEvolutionKey2026
3. في واجهة **Evolution Manager**:
   - اضغط على **New Instance** (إنشاء جلسة جديدة).
   - اكتب اسماً للبوت، مثلاً: usiness_bot_1.
   - حدد نوع التكامل: Baileys.
4. اضغط على **Create & Connect**:
   - سيظهر لك **QR Code** على الشاشة فوراً.
5. افتح تطبيق **WhatsApp** على هاتفك:
   - توجه إلى: **الأجهزة المرتبطة (Linked Devices)** ➔ **ربط جهاز (Link a device)**.
   - قم بمسح الـ QR Code الظاهر أمامك على الشاشة.
6. مبروك! بمجرد المسح ستتحول الحالة إلى **Connected** ويصبح رقم الواتساب جاهزاً لاستقبال وإرسال الرسائل وربطه بسيرفر الـ n8n.
