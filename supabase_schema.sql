-- ==============================================================================
-- Schema for WhatsApp Bot Factory - Bookings & Customer Orders
-- ==============================================================================

-- تفعيل امتداد uuid لإنشاء معرفات فريدة
CREATE EXTENSION IF NOT EXISTS uuid-ossp;

-- إنشاء جدول bot_records
CREATE TABLE IF NOT EXISTS bot_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_name VARCHAR(150) NOT NULL,
    customer_name VARCHAR(150) NOT NULL,
    customer_phone VARCHAR(50) NOT NULL,
    requested_service VARCHAR(255) NOT NULL,
    scheduled_date TIMESTAMPTZ,
    notes TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('Africa/Cairo', now())
);

-- إنشاء فهارس (Indexes) لتسريع عمليات البحث والاستعلام
CREATE INDEX IF NOT EXISTS idx_bot_records_business ON bot_records(business_name);
CREATE INDEX IF NOT EXISTS idx_bot_records_customer_phone ON bot_records(customer_phone);
CREATE INDEX IF NOT EXISTS idx_bot_records_status ON bot_records(status);
CREATE INDEX IF NOT EXISTS idx_bot_records_created_at ON bot_records(created_at DESC);

-- تفعيل سياسة الأمان RLS (Row Level Security)
ALTER TABLE bot_records ENABLE ROW LEVEL SECURITY;

-- سياسة سماح القراءة والكتابة للـ Service Role أو Public مع التحقق
CREATE POLICY Allow public insert and select on bot_records 
ON bot_records
FOR ALL
USING (true)
WITH CHECK (true);

COMMENT ON TABLE bot_records IS 'جدول تخزين حجوزات ومحادثات العملاء لمصنع بوتات الواتساب';
