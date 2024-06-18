const express = require('express');
const app = express();
const port = 3001;

app.get('/clientes', (req, res) => {
  res.json([{ id: 1, nombre: 'Cliente A' }, { id: 2, nombre: 'Cliente B' }]);
});

app.listen(port, () => {
  console.log(`Servicio de Cliente corriendo en el puerto ${port}`);
});
