-- Users
CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  nama VARCHAR(150) NOT NULL,
  email VARCHAR(150),
  phone VARCHAR(30),
  role ENUM('siswa','kepala_sekolah','waka_kesiswaan','waka_kurikulum','bk','tata_usaha') NOT NULL,
  profile VARCHAR(255), -- link foto profil
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reports
CREATE TABLE reports (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  reporter_id BIGINT UNSIGNED NOT NULL,
  target_user_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  status ENUM('baru','proses','diterima','ditolak','selesai') NOT NULL DEFAULT 'baru',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (target_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Foto laporan (bisa lebih dari satu)
CREATE TABLE report_photos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  report_id BIGINT UNSIGNED NOT NULL,
  photo_url VARCHAR(255) NOT NULL,
  uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Chats (bisa teks + foto)
CREATE TABLE chats (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  report_id BIGINT UNSIGNED NOT NULL,
  sender_id BIGINT UNSIGNED NOT NULL,
  message TEXT NULL, -- bisa kosong jika hanya foto
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Foto chat (bisa lebih dari satu per chat)
CREATE TABLE chat_photos (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  chat_id BIGINT UNSIGNED NOT NULL,
  photo_url VARCHAR(255) NOT NULL,
  uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (chat_id) REFERENCES chats(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Notifications
CREATE TABLE notifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,   -- penerima notifikasi
  report_id BIGINT UNSIGNED NULL,     -- notifikasi terkait laporan
  sender_id BIGINT UNSIGNED NULL,     -- pengirim notifikasi (siswa/guru)
  title VARCHAR(200) NOT NULL,        -- contoh: "Ruang Multimedia"
  message TEXT NOT NULL,              -- isi notifikasi
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE SET NULL,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;