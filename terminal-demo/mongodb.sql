// DEMO: MONGODB AUDIT LOG
// Jalankan lewat: docker exec -it doms-mongo mongosh -u doms_admin -p mongo_pass123 --authenticationDatabase admin


use doms_audit;

//  Insert log baru: login 
db.audit_logs.insertOne({
    user_id: "eeeeeeee-0000-0000-0000-000000000001",
    activity_type: "LOGIN",
    description: "Admin HIMA login ke sistem",
    node_origin: "hima",
    metadata: {},
    created_at: new Date()
});

//  Insert log: pembuatan surat 
db.audit_logs.insertOne({
    user_id: "eeeeeeee-0000-0000-0000-000000000001",
    activity_type: "CREATE_LETTER",
    description: "HIMA membuat surat pemberitahuan seminar TI",
    node_origin: "hima",
    metadata: { letter_title: "Surat Pemberitahuan Seminar Teknologi Informasi" },
    created_at: new Date()
});

//  Insert log: approval oleh BEM 
db.audit_logs.insertOne({
    user_id: "dddddddd-0000-0000-0000-000000000001",
    activity_type: "APPROVE_LETTER",
    description: "BEM menyetujui surat dari HIMA",
    node_origin: "bem",
    metadata: { letter_title: "Surat Pemberitahuan Seminar Teknologi Informasi" },
    created_at: new Date()
});

//  Insert log: sinkronisasi kalender 
db.audit_logs.insertOne({
    user_id: "bbbbbbbb-0000-0000-0000-000000000001",
    activity_type: "SYNC_CALENDAR",
    description: "Kalender otomatis tersinkron setelah surat & proposal disetujui",
    node_origin: "kemahasiswaan",
    metadata: { event_name: "Seminar Teknologi Informasi 2026" },
    created_at: new Date()
});

//  Query: lihat semua log terbaru 
db.audit_logs.find().sort({ created_at: -1 }).limit(10).pretty();

//  Query: filter log berdasarkan node asal 
db.audit_logs.find({ node_origin: "hima" }).pretty();

//  Query: filter log berdasarkan jenis aktivitas 
db.audit_logs.find({ activity_type: "APPROVE_LETTER" }).pretty();

//  Aggregasi: hitung jumlah aktivitas per node 
db.audit_logs.aggregate([
    { $group: { _id: "$node_origin", total: { $sum: 1 } } },
    { $sort: { total: -1 } }
]);