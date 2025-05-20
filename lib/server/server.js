const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// konfigurasi koneksi MySQL
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',     // sesuaikan username MySQL mu
  password: '',     // sesuaikan password MySQL mu
  database: 'peta'
});

// koneksi ke MySQL
connection.connect(error => {
  if (error) {
    console.error('Koneksi MySQL gagal:', error);
  } else {
    console.log('Koneksi MySQL berhasil');
  }
});

// endpoint ambil semua lokasi
app.get('/lokasi', (req, res) => {
  connection.query('SELECT * FROM map', (error, results) => {
    if (error) {
      res.status(500).json({ error: 'Database error' });
    } else {
      res.json(results);
    }
  });
});

// endpoint ambil data lokasi berdasarkan id
app.get('/lokasi/:id', (req, res) => {
  const id = req.params.id;

  connection.query(
    'SELECT * FROM map WHERE id = ?',
    [id],
    (error, results) => {
      if (error) {
        res.status(500).json({ error: 'Database error' });
      } else if (results.length === 0) {
        res.status(404).json({ error: 'Lokasi tidak ditemukan' });
      } else {
        res.json(results[0]);
      }
    }
  );
});

app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
