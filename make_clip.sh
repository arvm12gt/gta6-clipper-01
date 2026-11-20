#!/bin/sh
# gta6-clipper-01: cut a 30 s vertical Short from Rockstar's GTA VI Trailer 2.
#
# Source: Rockstar Games, "Grand Theft Auto VI Trailer 2"
# (https://www.youtube.com/watch?v=VQRLujxTm3c), downloaded in this session
# with yt-dlp as trailer2.mp4. The trailer was captured entirely in-game on
# PlayStation 5; this script only trims, crops and captions it.
#
# The clip: trailer 117.0s -> 142.0s (25 s), then a 5 s pitch card.
# Why this stretch: it opens on the police-car explosion (the trailer's
# biggest single beat, a hook that lands in the first 2 seconds), runs
# through Vice City street colour, a breather, and closes on the iconic
# motorcycle-under-a-plane shot and the boat chase. One continuous segment,
# no re-ordering, no other source mixed in.
#
# Layout: 1080x1920 vertical (a centre crop of the 1920x1080 frame, so the
# action stays centred; the explosion, the bike and the boat all sit
# mid-frame). Hook text over the first 2.5 s, a small "OUT NOW" line at
# seconds 3-9, then the make.fun pitch card for the last 5 s.
#
# Usage: ./make_clip.sh [input.mp4] [output.mp4]
# Defaults: trailer2.mp4 in this directory -> gta6-short.mp4

set -eu

SRC="${1:-trailer2.mp4}"
OUT="${2:-gta6-short.mp4}"
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

# Trailer segment: 25 s of footage, then a 5 s card. Total 30 s.
START=117
LEN=25
CARD=5

ffmpeg -y -v error -i "$SRC" -filter_complex \
"[0:v]trim=start=${START}:end=$((START + LEN)),setpts=PTS-STARTPTS,\
crop=608:1080:(in_w-608)/2:0,scale=1080:1920:flags=lanczos,fps=30,setsar=1,\
drawtext=fontfile=${FONT}:text='GTA 6 IS FINALLY HERE':fontsize=72:fontcolor=white:borderw=5:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=28:x=(w-text_w)/2:y=150:enable='between(t,0,2.5)',\
drawtext=fontfile=${FONT}:text='GRAND THEFT AUTO VI - OUT NOW':fontsize=44:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=18:x=(w-text_w)/2:y=1620:enable='between(t,3,9)'[vtrailer]; \
color=black:1080x1920:d=${CARD},fps=30,format=yuv420p,setsar=1,\
drawtext=fontfile=${FONT}:text='Made by an AI agent':fontsize=54:fontcolor=white:x=(w-text_w)/2:y=640,\
drawtext=fontfile=${FONT}:text='for a \$500 bounty on make.fun':fontsize=54:fontcolor=white:x=(w-text_w)/2:y=730,\
drawtext=fontfile=${FONT}:text='You can earn money making':fontsize=54:fontcolor=white:x=(w-text_w)/2:y=930,\
drawtext=fontfile=${FONT}:text='clips with AI on make.fun':fontsize=54:fontcolor=white:x=(w-text_w)/2:y=1020,\
drawtext=fontfile=${FONT}:text='make.fun/bounty/gta6-clipper-01':fontsize=46:fontcolor=0x7CFFB2:x=(w-text_w)/2:y=1240,fade=t=in:st=0:d=0.5[vcard]; \
[vtrailer][vcard]concat=n=2:v=1:a=0[vout]; \
[0:a]atrim=start=${START}:end=$((START + LEN)),asetpts=PTS-STARTPTS,afade=t=out:st=24:d=1,apad=whole_dur=$((LEN + CARD))[aout]" \
-map "[vout]" -map "[aout]" \
-c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -r 30 \
-c:a aac -b:a 128k -movflags +faststart "$OUT"

ffprobe -v error -show_entries format=duration,size \
  -show_entries stream=codec_name,width,height -of default=noprint_wrappers=1 "$OUT"
echo "wrote $OUT"
