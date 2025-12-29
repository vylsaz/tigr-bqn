⟨_WindowWithFlag, Free, tfont, tk ⇐ key, flag⟩ ← •Import "../../tigr.bqn"

And ← {⟨𝕨⟩32•bit._and⟨𝕩⟩}
MakeDemoWindow ← {"Flag tester" 𝕨 _WindowWithFlag 𝕩}
DrawDemoWindow ← {𝕊 win:
    lineColor ← 100‿100‿100
    lineColor win.Line ⟨0, 0, (win.W@)-1, (win.H@)-1⟩
    lineColor win.Line ⟨0, (win.H@)-1, (win.W@)-1, 0⟩
    200‿10‿10 win.Rect ⟨0, 0, win.W@, win.H@⟩
    20‿200‿0 win tfont._Print_({𝕨∾"x"∾𝕩}´•Fmt¨(win.W∾win.H)@) 5‿5
}

DrawToggle ← {text‿checked‿value‿key‿color 𝕊 bmp‿x‿y‿stride:
    h ← tfont.TextHeight text
    w ← tfont.TextWidth text

    yOffset ← ⌊stride÷2
    xOffset ← ⌊w÷¯2
    color bmp tfont._Print_ text ⟨x+xOffset, y+yOffset⟩
    yOffset +↩ {checked? h; ⌊h÷3}
    lineColor ← color∾240
    lineColor bmp.Line ⟨x+xOffset, y+yOffset, x+xOffset+w, y+yOffset⟩
}

flags ← 0
initialW ← 400
initialH ← 400
win ← flags MakeDemoWindow ⟨initialW, initialH⟩

white ← 255‿255‿255
yellow ← 255‿255‿0
black ← 0‿0‿0

toggles ← ⟨
    ⟨ "(A)UTO", 0, flag.auto, 'A', white ⟩
    ⟨ "(R)ETINA", 0, flag.retina, 'R', white ⟩
    ⟨ "(F)ULLSCREEN", 0, flag.fullscreen, 'F', white ⟩
    ⟨ "(2)X", 0, flag.scale2x, '2', yellow ⟩
    ⟨ "(3)X", 0, flag.scale3x, '3', yellow ⟩
    ⟨ "(4)X", 0, flag.scale4x, '4', yellow ⟩
    ⟨ "(N)OCURSOR", 0, flag.nocursor, 'N', white ⟩
⟩

{𝕊:
    win.Clear black
    DrawDemoWindow win

    numToggles ← ≠toggles
    stepY ← ⌊(win.H@)÷numToggles
    toggleY ← 0
    toggleX ← ⌊(win.W@)÷2

    {
        newFlags ← 0
        {𝕊 i:
            text‿checked‿value‿key‿color ← i⊑toggles
            {win.KeyDown key? checked ¬↩; @}
            newFlags +↩ checked×value
            toggle ← text‿checked‿value‿key‿color
            toggle DrawToggle win‿toggleX‿toggleY‿stepY
            toggles toggle⌾(i⊸⊑)↩ 
            toggleY +↩ stepY
        }¨↕numToggles

        {flags≠newFlags?
            modeFlags ← flag.auto+flag.retina
            modeChange ← (flags And modeFlags)≢newFlags And modeFlags
            flags ↩ newFlags

            w ← {modeChange? initialW; win.W@}
            h ← {modeChange? initialH; win.H@}
            Free win
            win ↩ flags MakeDemoWindow ⟨w, h⟩
        ;@}
    }

    win.Update@
}•_while_{𝕊: (¬ win.Closed @)∧¬ win.KeyDown tk.escape}@
Free win
