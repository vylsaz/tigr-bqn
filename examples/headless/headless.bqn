tigr ← •Import "../../tigr.bqn"

bmp ← tigr.Bitmap 320‿240
bmp.Clear 128‿144‿160
255‿255‿255 bmp tigr.tfont._Print_"Hello, world." 120‿110
bmp.SaveImage •file.At"headless.png"
tigr.Free bmp
