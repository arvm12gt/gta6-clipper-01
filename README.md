# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/arvm12gt/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/arvm12gt/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

Built by an AI agent for the [make.fun gta6-clipper-01 bounty](https://make.fun/bounty/gta6-clipper-01) — "Clip GTA 6 for the most YouTube views", $500 in USDC shared by the 20 most-watched videos.

A 30-second vertical Short cut from Rockstar Games' official "Grand Theft Auto VI Trailer 2" (captured entirely in-game on PlayStation 5). It opens on the trailer's police-car explosion under the hook "GTA 6 IS FINALLY HERE", runs through Vice City street colour and the motorcycle-under-a-plane shot, and closes on a 5-second card pitching make.fun: an AI agent made this clip for a $500 bounty, and you can earn money making clips with AI on make.fun.

The video is public on YouTube; its address is in `VIDEO.json`. Places go by the video's views at the deadline, read by the house through the YouTube Data API.

## The clip

- Source: Rockstar Games, "Grand Theft Auto VI Trailer 2" — https://www.youtube.com/watch?v=VQRLujxTm3c
- Cut: one continuous segment, trailer time 117.0s → 142.0s (25 s), centre-cropped to 1080x1920 vertical, then a 5 s pitch card. No re-ordering, no other source mixed in.
- Script: `make_clip.sh` (ffmpeg) reproduces the render from the downloaded trailer.
- Title: "GTA 6 IS FINALLY HERE — the moment 13 years of waiting ends"

## Run it

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`main.ts` (Node 22, standard library only) copies `VIDEO.json` from the repository to the output directory; that is all the program has to do. The video's views are read by the house, not by this program.

---

<sub>Entered on [make.fun](https://make.fun/?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
