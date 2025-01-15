tigr ← •Import "../../tigr.bqn"

tk ← tigr.key
tfont ← tigr.tfont

standing ← 1
remaining ← 0

pl ← 160‿200
pls ← 0‿0

backdrop ← @
screen ← @

Update ← {𝕊 dt:
    {remaining>0? remaining -↩ dt; @}

    pls +↩ ({
        ∨´screen.KeyHeld¨tk.left‿'A'? ¯10; 0
    }+{
        ∨´screen.KeyHeld¨tk.right‿'D'? 10; 0
    })‿{
        standing∧screen.KeyDown tk.space? ¯200; 0
    }
    
    old ← pl

    pls ×↩ ⋆dt×¯10‿¯2
    pls +↩ dt×0‿200
    pl +↩ dt×pls
 
    {(⊑pl)<8? 
        pl ↩ 8‿0+0‿1×pl
        pls ×↩ 0‿1
    ;@}
    {(⊑pl)>x←(screen.W@)-8? 
        pl ↩ x‿0+0‿1×pl
        pls ×↩ 0‿1
    ;@}

    d ← (pl-old)÷10
    standing ↩ 0
    {𝕊:
        p0 ← backdrop.Get ⌊old-0‿1
        old -↩ ⟨0, ∧´0=3↑p0⟩
        p1 ← backdrop.Get ⌊old
        {(0<1⊑pls)∧∧´0=3↑p1?
            pls ×↩ 1‿0
            d ×↩ 1‿0
            standing ↩ 1
        ;@}
        old +↩ d
    }⍟10 @

    pl ↩ old
}

squinkle ← tigr.LoadImage •file.At "squinkle.png"
greeting ← •FChars "greeting.txt"

screen ↩ greeting tigr.flag.scale2x tigr._WindowWithFlag 320‿240
backdrop ↩ tigr.Bitmap screen.Size@

backdrop.Clear 80‿180‿255
60‿120‿60 backdrop.Fill 0‿200‿320‿40
0‿0‿0 backdrop.Fill 0‿200‿320‿3
255‿255‿255 backdrop.Line 0‿201‿320‿201

screen.SetPostFX 1‿1‿1‿2

prev ← 0
prevXY ← 0‿0

chars ← 16⥊'_'

{𝕊:
    Update tigr.Time@
    
    x‿y‿b ← screen.Mouse@
    {1=2|b?
        {prev? 0‿0‿0 backdrop.Line prevXY∾⟨x,y⟩; @}
        prevXY ↩ x‿y
        prev ↩ 1
    ;
        prev ↩ 0
    }

    0‿0 screen tigr._Blit_ backdrop 0‿0
    (⌊pl-0.5‿1×squinkle.Size@) screen tigr._BlitAlpha_⟨squinkle, 1⟩ 0‿0

    192‿208‿255‿192 screen tfont._Print_ greeting 10‿10
    255‿255‿255 screen tfont._Print_"A D + SPACE" 10‿222

    {
        s ← ""
        c ← screen.ReadChar@
        {𝕊:
            s ∾↩ c
            c ↩ screen.ReadChar@
        }•_while_{𝕊: c≠@} @
        chars ↩ ¯16↑chars∾s
    }
    255‿255‿255 screen tfont._Print_("Chars: "∾chars)160‿222

    screen.Update@
}•_while_((¬ screen.Closed)∧(¬ screen.KeyDown⟜tk.escape)) @

tigr.Free screen
tigr.Free backdrop
tigr.Free squinkle

