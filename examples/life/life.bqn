tigr ← •Import "../../tigr.bqn"

Life←{
    r ← ¯1(⌽⎉1)¯1⌽(2+≢𝕩)↑𝕩
    s ← ∨´ (1∾<r) ∧ 3‿4 = <+´⥊ ¯1‿0‿1 (⌽⎉1)⌜ ¯1‿0‿1 ⌽⌜ <r
    1(↓⎉1) ¯1(↓⎉1) 1↓ ¯1↓s
}

width‿height ← 100‿100
old ← @
new ← height‿width •rand.Range 2

palette ← ⟨
    0‿0‿0‿255
    255‿0‿0‿255
    105‿105‿105‿255
    255‿255‿255‿255
⟩ 

fps ← 16

pause ← 0

tigr.With ("life" tigr.Window width‿height)‿{ 𝕊 win:
    { win.KeyDown tigr.key.space?
        pause ¬↩
    ;
        •Delay ÷fps
    }
    { pause∧¬win.KeyDown 'F'? @;
        old ↩ new
        new ↩ Life old
    }
    x‿y‿b ← win.Mouse @
    { ∧´(0⊸≤∧<⟜width‿height) x‿y?
        { 1=b?
            new 1⌾(y‿x⊸⊑)↩
        ; 4=b?
            new 0⌾(y‿x⊸⊑)↩
        ; @
        }
    ; @
    }
    win.WritePix palette⊏˜old+2×new
    win.Update @
}
