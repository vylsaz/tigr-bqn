tigr ← •Import "../../tigr.bqn"

tfont ← tigr.tfont

c0 ← 55‿55‿55
c1 ← 255‿255‿255
c2 ← 100‿200‿100
c3 ← 100‿100‿200‿150

{𝕊 win: 
    win.Clear c0

    c ← ⌊0.5×win.Size@
    w‿d ← 100‿50

    win.Clip    (c-d)∾⟨w, w⟩
    c1 win.Fill (c-d)∾⟨w, w⟩

    c2 win.Rect     (c-w)∾⟨w, w⟩
    c3 win.FillRect (c-w)∾⟨w, w⟩

    c2 win.Circle     (c+⟨d,-d⟩)∾<d
    c3 win.FillCircle (c+⟨d,-d⟩)∾<d

    msg ← "Half a thought is also a thought"
    sz ← tfont.TextSize msg

    c2 win tfont._Print_ msg ⟨0,d⟩+c-⌊0.5×sz

    win.Update@
}tigr._WithWindow_"Clip" 320‿240 
