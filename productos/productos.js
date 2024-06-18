const express = require('express');
const app = express();
const port = 3002;

app.get('/productos', (req, res) => {
  res.json([{ id: 1, nombre: 'Producto A' }, { id: 2, nombre: 'Producto B' }]);
});

app.listen(port, () => {
  console.log(`Servicio de Productos corriendo en el puerto ${port}`);
});
