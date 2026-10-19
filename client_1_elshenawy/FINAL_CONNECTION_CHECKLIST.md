# قائمة التحقق والتشغيل النهائي (Final Connection Checklist)

دليل الربط الكامل لـ **مصنع بوتات واتساب** - عميل عيادات الشناوي لطب الأسنان (فرع مدينة نصر).

---

## 1. ربط واستيراد الـ Workflow في n8n

1. افتح لوحة تحكم سيرفر n8n الخاص بك:
   👉 [https://whatsapp-bot-factory.onrender.com](https://whatsapp-bot-factory.onrender.com)
2. من القائمة الجانبية، ادخل إلى **Workflows** ثم اضغط على زر الخيارات **(...)** أعلى اليمين واختر **Import from File**.
3. اختر ملف 
8n_evolution_whatsapp_workflow.json الموجود في مجلد client_1_elshenawy.
4. بعد استيراد التدفق:
   - اضغط على عقدة **Google Gemini Chat Model** وأضف الـ **Gemini API Key** الخاص بك في خانة الاعتماد (Credentials).
   - فعّل التدفق بالضغط على مفتاح **Active** بالأعلى.

---

## 2. ضبط الـ Webhook في Evolution API

لكي ترسل Evolution API أي رسالة واتساب جديدة فوراً إلى n8n:
1. تأكد من أن الـ Webhook URL الخاص بـ n8n هو:
   `
   https://whatsapp-bot-factory.onrender.com/webhook/evolution-whatsapp
   `
2. يمكنك تفعيله من خلال واجهة **Evolution Manager** أو بإرسال طلب HTTP التالي:
   - **Method**: POST
   - **URL**: https://evolution-whatsapp-bridge.onrender.com/webhook/set/elshenawy_clinic
   - **Headers**:
     - pikey: MySuperSecretEvolutionKey2026
     - Content-Type: pplication/json
   - **Body**:
     `json
     {
       webhook: {
         enabled: true,
         url: https://whatsapp-bot-factory.onrender.com/webhook/evolution-whatsapp,
         byEvents: false,
         base64: false,
         events: [
           MESSAGES_UPSERT
         ]
       }
     }
     `

---

## 3. ميزة التدخل البشري الذكي (Human Takeover)

تم تصميم الـ Workflow ليتعامل بذكاء مع الردود اليدوية:
- عندما يقوم الطبيب أو موظف العيادة بالرد مباشرة على المحادثة من تطبيق الواتساب في الهاتف (romMe == true):
  - يقوم التدفق فوراً بتسجيل حالة هذا الرقم كـ human_takeover في جدول ot_records في Supabase.
  - يتوقف البوت تلقائياً عن الرد على هذا المريض لمنع أي تضارب بين الطبيب والبوت.
- عندما يرسل العميل رسالة جديدة، يتأكد البوت أولاً هل المحادثة متوقفة للتدخل البشري أم مسموح له بالرد تلقائياً.

---

## 4. محاكاة الرد البشري والأدوات

- **Human Typing Delay**: تم ضبط تأخير لمدة 2.5 ثانية قبل إرسال الرسالة لمحاكاة سرعة الكتابة البشرية الطبيعية وتفادي الحظر.
- **Check_Appointments_Tool**: لفحص المواعيد المتاحة والتأكد من عدم وجود تعارض.
- **Book_Appointment_Tool**: لتأكيد الحجز وكتابته في جدول ot_records مع اسم المريض، الهاتف، والخدمة المطلوبة.

---

## 5. هل ترغب في إنشائه واستيراده مباشرة عبر n8n API؟

إذا قمت بإنشاء **n8n API Key** من لوحة التحكم (Settings ➔ n8n API) وتزويدي به:
- سأقوم برفع وضبط وتفعيل الـ Workflow بالكامل داخل حساب n8n بدون أي تدخل يدوي منك!
