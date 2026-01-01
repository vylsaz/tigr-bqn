tigr ← •Import "../../tigr.bqn"
font ← tigr.tfont

Num ← {'-'¨⌾(('¯'=f)⊸/)f ← •Fmt 𝕩}

screen ← "test" tigr.Window 320‿240

{𝕊: 
    screen.Clear 25‿25‿25
    255‿255‿255 screen font._Print_{
        x‿y ← screen.ScrollWheel @
        "scroll x="∾(Num x)∾", y="∾Num y
    } 120‿90
    255‿255‿255 screen font._Print_{
        x‿y‿b ← screen.Mouse @
        pressed ← 3↑32‿1•bit._cast ⟨b⟩
        "mouse x="∾(Num x)∾", y="∾(Num y)∾", pressed "∾1↓∾(" "∾Num)¨pressed
    } 60‿120
    screen.Update@
}•_while_((¬ screen.Closed)∧(¬ screen.KeyDown⟜tigr.key.escape))@

{ 0=≠•args?
    screen.Error "test error function!"
;@
}

tigr.Free screen
