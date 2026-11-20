# Database Testing – The Reds Gaming Lounge

## 1. Overview
Pengujian dilakukan untuk memastikan database The Reds Gaming Lounge dapat mengelola data pelanggan, karyawan, unit PlayStation, booking, detail booking, dan pembayaran dengan benar.

## 2. Testing Results

| No| Pengujian | Hasil |
| 1 | JOIN booking dengan pelanggan | Berhasil menampilkan 3 data booking |
| 2 | JOIN booking dengan unit PlayStation | Berhasil menampilkan 4 detail pemesanan |
| 3 | Perhitungan total biaya booking | Berhasil menghitung biaya berdasarkan durasi dan tarif |
| 4 | Perhitungan pembayaran dan sisa tagihan | Berhasil menghitung total pembayaran dan sisa tagihan |
| 5 | Riwayat pembayaran pelanggan | Berhasil menampilkan 5 transaksi pembayaran |
| 6 | Pemeriksaan status pelunasan | Berhasil mengidentifikasi status pembayaran |

## 3. Payment Calculation Results

| Pelanggan | Total Biaya | Total Dibayar | Sisa Tagihan | Status |
|---|---:|---:|---:|---|
| Andi Pratama | Rp40.000 | Rp40.000 | Rp0 | Lunas |
| Budi Santoso | Rp100.000 | Rp100.000 | Rp0 | Lunas |
| Citra Amelia | Rp20.000 | Rp20.000 | Rp0 | Lunas |

## 4. Conclusion
Berdasarkan pengujian yang dilakukan, database The Reds Gaming Lounge berhasil menjalankan operasi penggabungan data, perhitungan biaya, pencatatan pembayaran, dan pemeriksaan status pelunasan. Seluruh pengujian menghasilkan output sesuai dengan data yang tersimpan di database.
