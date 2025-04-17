# bad apple script
this script only works in an executor;
required functions can be seen at the top of `apple.lua`

easy steps:
1. move `bad_apple` folder into your exploit's workspace folder
2. copy the content of `apple.lua` and execute
3. done

if you wish to parse frames yourself, run `py apple.py bad_apple.mp4`, where `bad_apple.mp4` is the original bad apple video

you can change the width (and height):`py apple.py bad_apple.mp4 [--outdir <dir>] [--fps <int>] [--size <width> <height>] [--fpc <frames_per_chunk>]`
