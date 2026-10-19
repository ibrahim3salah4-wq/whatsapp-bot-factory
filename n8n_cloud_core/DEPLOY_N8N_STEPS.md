# دليل نشر وتشغيل n8n مجاناً على منصة Render باستخدام Supabase Database

هذا الدليل يوضح خطوات نشر محرك الأتمتة **n8n** على منصة **Render** كـ **Web Service** مجاني، مع ربطه بقاعدة بيانات سحابية دائمة ومجانية من **Supabase** (PostgreSQL) لضمان عدم ضياع التدفقات (Workflows) وبيانات الاعتماد (Credentials) عند إعادة تشغيل الخادم.

---

## 1. تجهيز قاعدة البيانات على Supabase

1. أنشئ حساباً مجانياً على [Supabase](https://supabase.com).
2. أنشئ مشروعاً جديداً (New Project) واختر اسماً وكلمة سر قوية لقاعدة البيانات (احفظ كلمة السر جيداً).
3. بعد اكتمال إنشاء المشروع، توجه إلى:
   - **Project Settings** (أيقونة الترس بالأسفل) ➔ **Database**.
4. مرّر للأسفل حتى قسم **Connection parameters**، وستجد البيانات التالية:
   - **Host**: عادة بصيغة db.[PROJECT_REF].supabase.co
   - **Database name**: postgres
   - **Port**: 5432 (أو 6543 للـ Pooler)
   - **User**: postgres
   - **Password**: كلمة السر التي اخترتها عند إنشاء المشروع

---

## 2. رفع مجلد 
8n_cloud_core إلى GitHub

1. افتح سطر الأوامر (Terminal / PowerShell) داخل مجلد المشروع.
2. يمكنك تهيئة مستودع Git ورفع الملفات:
   `ash
   git init
   git add n8n_cloud_core
   git commit -m Add n8n cloud core for Render
   git branch -M main
   git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPOSITORY>.git
   git push -u origin main
   `
   *(أو ارفع مجلد 
8n_cloud_core مباشرة عبر واجهة موقع GitHub).*

---

## 3. النشر على منصة Render

### الطريقة الأولى: النشر السريع عبر Blueprint (باستخدام ender.yaml)
1. سجّل الدخول إلى [Render](https://render.com).
2. في لوحة التحكم، اضغط على **Blueprints** ثم **New Blueprint Instance**.
3. اربط مستودع GitHub الخاص بك.
4. حدد مسار ملف الـ blueprint إذا كان داخل المجلد (مثلاً: 
8n_cloud_core/render.yaml).
5. سيتعرف Render على الإعدادات تلقائياً وسيطلب منك إدخال المتغيرات السرية (DB_POSTGRESDB_HOST و DB_POSTGRESDB_PASSWORD).

---

### الطريقة الثانية: النشر اليدوي كـ Web Service (خطوة بخطوة)
1. في لوحة تحكم Render، اضغط على **New +** ➔ اختر **Web Service**.
2. اختر مستودع الـ GitHub الخاص بك واضغط **Connect**.
3. املأ الإعدادات كالتالي:
   - **Name**: 
8n-automation-engine (أو أي اسم تفضله).
   - **Region**: اختر الأقرب لك (مثل Frankfurt).
   - **Root Directory**: 
8n_cloud_core (لأن الـ Dockerfile داخله).
   - **Language / Environment**: Docker.
   - **Instance Type**: اختر **Free**.
4. توجّه لقسم **Environment Variables** وأضف المتغيرات التالية:

| اسم المتغير (Key) | القيمة (Value) | ملاحظة |
| :--- | :--- | :--- |
| PORT | 5678 | المنفذ الداخلي لـ Render |
| N8N_PORT | 5678 | منفذ تشغيل n8n الافتراضي |
| GENERIC_TIMEZONE | Africa/Cairo | التوقيت الإقليمي (القاهرة) |
| DB_TYPE | postgresdb | استخدام PostgreSQL كقاعدة بيانات |
| DB_POSTGRESDB_HOST | db.[PROJECT_REF].supabase.co | مسار السيرفر من Supabase |
| DB_POSTGRESDB_PORT | 5432 | منفذ الاتصال الافتراضي |
| DB_POSTGRESDB_DATABASE | postgres | اسم قاعدة البيانات الافتراضية |
| DB_POSTGRESDB_USER | postgres | اسم المستخدم الافتراضي |
| DB_POSTGRESDB_PASSWORD | <SUPABASE_PASSWORD> | كلمة سر قاعدة البيانات |
| DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED | alse | ضروري لتمكين اتصال SSL مع Supabase |
| WEBHOOK_URL | https://<YOUR_APP_NAME>.onrender.com/ | رابط التطبيق بعد إنشائه لتفعيل الـ Webhooks |

5. اضغط على **Create Web Service**.

---

## 4. بعد اكتمال النشر والتشغيل

1. انتظر من 2 إلى 4 دقائق ريثما يكتمل بناء صورة Docker وتشغيل الحاوية بنجاح.
2. راقب سجلات التشغيل (**Logs**) للتأكد من ظهور رسالة:
   `
   n8n ready on 0.0.0.0, port 5678
   Migrations completed successfully
   `
3. افتح الرابط العام الممنوح لك من Render (مثال: https://n8n-xxxx.onrender.com).
4. أنشئ حساب المالك الأول (Owner Account) وابدأ في بناء الـ Workflows!
