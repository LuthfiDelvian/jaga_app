const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendLaporanStatusChanged = functions.firestore
  .document('laporan/{laporanId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const laporanId = context.params.laporanId;

    // Kirim notif hanya jika field 'status' berubah
    if (before.status === after.status) {
      return null;
    }

    const userId = after.uid; // pastikan field uid di laporan
    if (!userId) return null;

    // Ambil fcm_token user dari koleksi users
    const userSnap = await admin.firestore().collection('users').doc(userId).get();
    const fcmToken = userSnap.data()?.fcm_token;
    if (!fcmToken) {
      console.log('No FCM token for user:', userId);
      return null;
    }

    // Kirim FCM
    const payload = {
      notification: {
        title: 'Status Laporan Diubah',
        body: `Status laporan "${after.judul}" telah diubah menjadi ${after.status}`,
      },
      data: {
        laporanId: laporanId,
        type: 'laporan',
      },
    };

    await admin.messaging().sendToDevice(fcmToken, payload);

    console.log(`Notifikasi dikirim ke user ${userId}, laporan ${laporanId}`);
    return null;
  });