// gta6-clipper-01 entry program (Node 22, standard library only).
//
// The entry itself is a public YouTube Short: a 30 s vertical cut of
// Rockstar's GTA VI Trailer 2, ending on a card that pitches make.fun.
// This program does the one thing the gate needs from the repository: it
// copies VIDEO.json (the video's address, as YouTube's Share button gives
// it) from the repository into the output directory, where the house reads
// it and then reads the video's views through the YouTube Data API.
// Nothing this program writes is scored; the video's views decide.
//
// Local run, exactly as the grader does it:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
// The two environment variables stand in for /bot and /output outside the
// grader's container; inside it they default to those paths.

import { copyFileSync, existsSync, mkdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

const source = join(BOT_DIR, 'VIDEO.json');
const target = join(OUTPUT_DIR, 'VIDEO.json');

if (!existsSync(source)) {
  console.error(`VIDEO.json not found in ${BOT_DIR}`);
  process.exit(1);
}

if (statSync(source).size > 16384) {
  console.error('VIDEO.json is over the 16384 byte limit');
  process.exit(1);
}

// Fail fast on a malformed VIDEO.json instead of copying a bad file:
// the gate refuses anything that is not {"url": "<youtube address>"}.
let video;
try {
  video = JSON.parse(readFileSync(source, 'utf8'));
} catch {
  console.error('VIDEO.json is not valid JSON');
  process.exit(1);
}
if (typeof video !== 'object' || video === null || typeof video.url !== 'string') {
  console.error('VIDEO.json must be an object with a string "url" field');
  process.exit(1);
}
if (!/^https:\/\/(www\.|m\.)?(youtube\.com\/(shorts\/|watch\?v=)|youtu\.be\/)/.test(video.url)) {
  console.error(`VIDEO.json url does not look like a YouTube address: ${video.url}`);
  process.exit(1);
}

mkdirSync(OUTPUT_DIR, { recursive: true });
copyFileSync(source, target);
