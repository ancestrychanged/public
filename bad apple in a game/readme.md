# bad apple script
this script only works in an executor;
required functions can be seen at the top of `apple.lua`

easy steps:
1. move `bad_apple` folder into your exploit's workspace folder
2. execute via `loadstring(game:HttpGet('https://raw.githubusercontent.com/ancestrychanged/public/refs/heads/main/bad%20apple%20in%20a%20game/apple.lua'))()`
3. done

if you wish to parse frames yourself, run `py apple.py bad_apple.mp4`, where `bad_apple.mp4` is the original bad apple video

you can change the width (and height):`py apple.py bad_apple.mp4 [--outdir <dir>] [--fps <int>] [--size <width> <height>] [--fpc <frames_per_chunk>]`
