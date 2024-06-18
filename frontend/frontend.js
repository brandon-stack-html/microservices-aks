const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

// Servir archivos estáticos (como index.html) desde el directorio "public"
app.use(express.static('public'));

// Ruta para servir el archivo HTML
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
  console.log(`Frontend corriendo en http://localhost:${port}`);
});
