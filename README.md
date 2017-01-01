# What is this?

A short Ruby script to aid in compressing and cutting videos, presenting a
simplified way to call ffmpeg's libx265 encoder.

# Usage

```bash
shrink.rb -i input.mp4 [options] --dest "mobile"
```

# Options

- `-i string`, input file (required)
- `--dest string`, destination folder (required)
- `--crf int`, a constant perceived quality
- `--bitrate int`, desired kilobits per second
- `--res string`, a resolution like `720p` or `1080p`
- `--offset string`, the timestamp to begin at, eg `01:20:14`
- `--segment int`, the number of seconds to encode

You can specify a CRF or a bitrate, but not both.

Unless otherwise specified, the entire video will be re-encoded at its existing
resolution.
