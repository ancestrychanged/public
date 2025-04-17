import argparse
import logging
import sys
import time
from pathlib import Path
import shutil

import cv2  # type: ignore
import numpy as np  # type: ignore
import lz4.block  # type: ignore

fps: int = 30
w: int = 96
h: int = 72
fpc: int = 180
characters: list[str] = ["　", "░", "▒", "▓", "█"]
lvs: int = len(characters)
characterpallette = np.array(characters)

def outputDirectory(path: Path, clobber: bool = True) -> None:
    if path.exists() and clobber:
        logging.info("removing dir %s", path)
        try:
            shutil.rmtree(path)
        except OSError as exc:
            logging.error("cant remove dir %s bc %s", path, exc)
            sys.exit(1)
    try:
        path.mkdir(parents=True, exist_ok=True)
    except OSError as exc:
        logging.error("cant create dir %s bc %s", path, exc)
        sys.exit(1)

def write_chunk(dir: Path, number: int, sizes: list[str], blobs: list[bytes]) -> None:
    hd = ",".join(sizes) + "\n"
    b = b"".join(blobs)
    cpath = dir / f"chunk_{number:04d}.txt"
    try:
        with cpath.open("wb") as fp:
            fp.write(hd.encode("utf-8"))
            fp.write(b)
        logging.debug("made %s (%d frames)", cpath.name, len(sizes))
    except OSError as exc:
        logging.error("cant make chunk %s bc %s", cpath, exc)

def frameToTheFuckingASCIIText(frame: np.ndarray) -> str:
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    indc = (lvs - 1) - np.floor(gray / (256.0 / lvs)).astype(int)
    indcClipped = np.clip(indc, 0, lvs - 1)
    arr = characterpallette[indcClipped]
    return "\n".join("".join(row) for row in arr)

def process(
    path: Path,
    output: Path,
    targetfps: int,
    targetw: int,
    targeth: int,
    _fpc: int,
) -> None:

    cap = cv2.VideoCapture(str(path))
    if not cap.isOpened():
        logging.error("cant open video: %s", path)
        sys.exit(1)

    sourceFrames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    logging.info("source vid ~%d frames @ %.2f fps", sourceFrames, cap.get(cv2.CAP_PROP_FPS))
    logging.info("target wxh is %dx%d @ %d fps", targetw, targeth, targetfps)

    # stats
    totalOriginal = 0
    totalComp = 0
    proccessedFrames = 0

    chunknumber = 1
    chunkSizes: list[str] = []
    chunkBlobs: list[bytes] = []

    delta = time.perf_counter()

    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                break

            f = cv2.resize(frame, (targetw, targeth), interpolation=cv2.INTER_AREA)
            asciiFrame = frameToTheFuckingASCIIText(f)
            originalBytes = asciiFrame.encode("utf-8")
            compBytes = lz4.block.compress(originalBytes, mode="default", store_size=False)

            totalOriginal += len(originalBytes)
            totalComp += len(compBytes)
            proccessedFrames += 1

            chunkSizes.append(f"{len(compBytes)}:{len(originalBytes)}")
            chunkBlobs.append(compBytes)

            # dump chunk when it’s full
            if len(chunkSizes) >= _fpc:
                write_chunk(output, chunknumber, chunkSizes, chunkBlobs)
                chunknumber += 1
                chunkSizes.clear()
                chunkBlobs.clear()

            if proccessedFrames % 2000 == 0:
                logging.info("went over %d/%d frames", proccessedFrames, sourceFrames)

    finally:
        cap.release()
    
    if chunkSizes:                                   # only if we actually have data
        write_chunk(output, chunknumber, chunkSizes, chunkBlobs)
    else:
        chunknumber -= 1

    ratio = totalOriginal / totalComp if totalComp else float("inf")
    elapsed = time.perf_counter() - delta

    logging.info("frames encoded: %d", proccessedFrames)
    logging.info("chunks made: %d", chunknumber)
    logging.info("original bytes: %s", f"{totalOriginal:,}")
    logging.info("compressed bytes: %s", f"{totalComp:,}")
    logging.info("ratio: %.2f:1", ratio)
    logging.info("elapsed: %.2f s", elapsed)

def argParser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser()
    p.add_argument(
        "video", 
        type=Path,
        help="path to the source video file")
    p.add_argument(
        "--outdir", "-o",
        type=Path,
        default=Path("bad_apple"),
        help="output directory (default: %(default)s)",
    )
    p.add_argument(
        "--fps",
        type=int,
        default=fps,
        help="target fps (default: %(default)s)",
    )
    p.add_argument(
        "--size",
        nargs=2,
        type=int,
        metavar=("WIDTH", "HEIGHT"),
        default=(w, h),
        help="target resolution (default: %(default)s)",
    )
    p.add_argument(
        "--fpc",
        type=int,
        default=fpc,
        help="frames per chunk (default: %(default)s)",
    )

    return p

def main(argv: list[str] | None = None) -> None:
    args = argParser().parse_args(argv)
    logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.INFO)
    logging.info("dir: %s", args.outdir)

    outputDirectory(args.outdir)

    width, height = args.size
    process(
        path=args.video,
        output=args.outdir,
        targetfps=args.fps,
        targetw=width,
        targeth=height,
        _fpc=args.fpc,
    )

if __name__ == "__main__":  # pragma: no cover
    main()
