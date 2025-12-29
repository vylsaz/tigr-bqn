tigr ← •Import "../../tigr.bqn"

background ← tigr.Hex "#101010"
foreground ← tigr.Hex "#50FF50"

width ← 800
height ← 800

Screen ← { 𝕊 x‿y:
    ⟨
        width×0.5×1+x
        height×1-0.5×1+y
    ⟩
}

Project ← { x‿y‿z: x‿y÷z }

TranslateZ ← { 0‿0‿𝕨 + 𝕩 }

RotateXZ ← { angle 𝕊 x‿y‿z:
    c ← •math.Cos angle
    s ← •math.Sin angle
    ⟨
        (c×x)-s×z
        y
        (c×z)+s×x
    ⟩
}

ctx ← "formula" tigr.Window width‿height

Point ← {
    s ← 20
    foreground ctx.FillRect ⌊s‿s∾˜𝕩-0.5×s
}

Line ← { 𝕊 ⟨x1‿y1, x2‿y2⟩:
    ¯1‿0‿1{foreground ctx.Line ⌊𝕨+𝕩}¨<x1‿y1‿x2‿y2
}

⟨ vs, fs ⟩ ← •Import "penger.bqn"

fps ← 60

dz ← 1
angle ← 0

Func ← {Screen Project dz TranslateZ angle RotateXZ 𝕩}

Frame ← { 𝕊:
    dt ← tigr.Time @
    angle +↩ π×dt

    ctx.Clear background

    # {Point Func 𝕩}¨vs

    {{Line Func¨vs⊏˜f⊏˜n|0‿1+𝕩}¨↕n ← ≠f ← 𝕩}¨fs

    ctx.Update @
}

Frame •_while_ (¬ ctx.Closed) @

tigr.Free ctx
