tigr ← •Import "../../tigr.bqn"

font ← tigr.tfont

screen ← "Hello" tigr.Window 320‿240

{𝕊: 
    screen.Clear 128‿144‿160
    255‿255‿255 screen font._Print_"Hello World!" 120‿110
    screen.Update@
}•_while_((¬ screen.Closed)∧(¬ screen.KeyDown⟜tigr.key.escape))@

tigr.Free screen
