// init.js - Inisialisasi database MongoDB untuk Audit Log DOMS
// Dijalankan otomatis saat container MongoDB pertama kali dibuat

db = db.getSiblingDB("doms_audit");

// Buat collection audit_logs
db.createCollection("audit_logs", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["user_id", "activity_type", "description", "node_origin", "created_at"],
            properties: {
                user_id: {
                    bsonType: "string",
                    description: "UUID user yang melakukan aktivitas"
                },
                activity_type: {
                    bsonType: "string",
                    enum: ["LOGIN", "LOGOUT", "CREATE_LETTER", "APPROVE_LETTER", "REJECT_LETTER",
                           "CREATE_PROPOSAL", "APPROVE_PROPOSAL", "REJECT_PROPOSAL",
                           "SYNC_CALENDAR", "REPLICATION_EVENT", "OTHER"],
                    description: "Jenis aktivitas yang dicatat"
                },
                description: {
                    bsonType: "string",
                    description: "Deskripsi detail aktivitas"
                },
                node_origin: {
                    bsonType: "string",
                    enum: ["kemahasiswaan", "bem", "hima", "ukm"],
                    description: "Node asal aktivitas"
                },
                metadata: {
                    bsonType: "object",
                    description: "Data tambahan (opsional), misal letter_id, proposal_id"
                },
                created_at: {
                    bsonType: "date",
                    description: "Waktu aktivitas dicatat"
                }
            }
        }
    }
});

// Index untuk pencarian cepat
db.audit_logs.createIndex({ user_id: 1 });
db.audit_logs.createIndex({ activity_type: 1 });
db.audit_logs.createIndex({ node_origin: 1 });
db.audit_logs.createIndex({ created_at: -1 });

// Seed contoh data audit log
db.audit_logs.insertMany([
    {
        user_id: "bbbbbbbb-0000-0000-0000-000000000001",
        activity_type: "LOGIN",
        description: "Admin Kemahasiswaan login ke sistem",
        node_origin: "kemahasiswaan",
        metadata: {},
        created_at: new Date()
    },
    {
        user_id: "eeeeeeee-0000-0000-0000-000000000001",
        activity_type: "CREATE_LETTER",
        description: "HIMA membuat surat pemberitahuan kegiatan seminar",
        node_origin: "hima",
        metadata: { letter_title: "Surat Pemberitahuan Seminar TI" },
        created_at: new Date()
    },
    {
        user_id: "dddddddd-0000-0000-0000-000000000001",
        activity_type: "APPROVE_LETTER",
        description: "BEM menyetujui surat dari HIMA",
        node_origin: "bem",
        metadata: { letter_title: "Surat Pemberitahuan Seminar TI" },
        created_at: new Date()
    }
]);

print("MongoDB audit_logs collection berhasil diinisialisasi.");