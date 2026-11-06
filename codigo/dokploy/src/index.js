const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Servir los archivos de la página web
app.use(express.static(path.join(__dirname, '../public')));

// Ruta de verificación del servidor
app.get('/health', (req, res) => {
  res.json({
    estado: 'saludable',
    aplicacion: 'Hospital San Juan de Dios de Armenia',
    version: '1.0.0'
  });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor del hospital iniciado en puerto ${PORT}`);
});
