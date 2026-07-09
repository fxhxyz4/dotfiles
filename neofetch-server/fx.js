import si from 'systeminformation';
import express from 'express';
import open from 'open';
import os from 'os';
import { exec } from 'child_process';
import { networkInterfaces } from 'os';

const app = express();
const local = `http://localhost`;
const port = 3000;

app.use(express.json());

app.get('/', async (req, res) => {
  try {
    const cpuInfo = await si.cpu();
    const memoryInfo = await si.mem();
    const graphicsInfo = await si.graphics();
    const baseboardInfo = await si.baseboard();
    const diskLayout = await si.diskLayout();
    const uptime = os.uptime();
    const kernel = os.release();

    const pacmanCount = await getCount('pacman -Q');
    const snapCount   = await getCount('snap list');
    const flatpakCount= await getCount('flatpak list');

    const ipAddress = getIpAddress();

    const formattedDiskLayout = diskLayout.map(disk => ({
      type: disk.type,
      interfaceType: disk.interfaceType,
      name: disk.name,
      size: formatBytes(disk.size),
    }));

    const data = {
      os: os.type(),
      arch: os.arch(),
      name: os.hostname(),
      processor: os.cpus()[0].model,
      platform: cpuInfo.platform,
      graphics: graphicsInfo.controllers[0].model,
      baseboard: baseboardInfo.model,
      totalMemory: formatBytes(memoryInfo.total),
      usedMemory: formatBytes(memoryInfo.used),
      freeMemory: formatBytes(memoryInfo.free),
      disks: formattedDiskLayout,
      kernel: kernel,
      uptime: `${Math.floor(uptime / 3600)}h ${Math.floor((uptime % 3600) / 60)}m`,
      ipAddress: ipAddress,
      packages: {
        pacman: pacmanCount,
        snap: snapCount,
        flatpak: flatpakCount
      }
    };

    res.json(data);
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

const formatBytes = (bytes) => {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  let i = 0;
  while (bytes >= 1024 && i < units.length - 1) {
    bytes /= 1024;
    i++;
  }
  return `${bytes.toFixed(2)} ${units[i]}`;
}

const getCount = (cmd) => {
  return new Promise((resolve) => {
    exec(cmd, (error, stdout) => {
      if (error) return resolve(0);
      const lines = stdout.split('\n').filter(Boolean);
      resolve(lines.length);
    });
  });
}

const getIpAddress = () => {
  const nets = networkInterfaces();
  for (const key in nets) {
    for (const net of nets[key]) {
      if (net.family === 'IPv4' && !net.internal) {
        return net.address.trim();
      }
    }
  }
  return 'N/A';
}

app.listen(port, '127.0.0.1', async () => {
  const url = `${local}:${port}`;
  console.log(`Server is running on http://localhost:${port}`);
  await open(url, { app: ['google chrome', '--incognito'] });
});
