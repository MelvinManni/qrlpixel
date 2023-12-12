import express from 'express';
import { qrCodeRoutes, redirectRoutes } from './routes/index.routes';

const host = process.env.HOST ?? 'localhost';
const port = process.env.PORT ? Number(process.env.PORT) : 3000;

const ROUTE_BASE = (path: string)=> `/api/${path}`;
const app = express();

app.set('trust proxy', true);
app.use(express.json());



app.get('/', (req, res) => {
  res.send({ message: "zWelcome to QRL Pixel API" });
});

app.use(ROUTE_BASE('qrcode'), qrCodeRoutes);
app.use("", redirectRoutes);



app.listen(port, host, () => {
  console.log(`[ ready ] http://${host}:${port}`);
});
