⟨Window, Free, tk ⇐ key, tfont⟩ ← •Import "../../tigr.bqn"

gl ← {
"windows":
    color_buffer_bit ⇐ 16384
    loadLibrary ← @•FFI ⟨"*", "LoadLibraryA", "*i8:c8"⟩
    LoadLibrary ⟨"Opengl32.dll"∾@⟩
    clear ⇐ @•FFI ⟨"", "glClear", "u32"⟩
    clearColor ⇐ @ •FFI ⟨"", "glClearColor","f32","f32","f32","f32"⟩
;
    !"TODO: load opengl"
}•platform.os

win1 ← "Window1" Window 320‿240
win2 ← "Window2" Window 320‿240

{𝕊:
    {@: @;
        win1.Clear 128‿144‿160
        255‿255‿255 win1 tfont._Print_"Hello, world #1." 120‿110
        win1.Update@

        {(win1.Closed@)∨win1.KeyDown tk.escape?
            Free win1
            win1 ↩ @
        ;@}
    }win1
    {@: @;
        {win2.BeginOpenGL@?
            gl.ClearColor ⟨1,0,1,1⟩
            gl.Clear ⟨gl.color_buffer_bit⟩
        ;@}

        win2.Clear 0‿0‿0‿0
        255‿255‿255 win2 tfont._Print_"Hello, world #2." 120‿110
        win2.Update@

        {(win2.Closed@)∨win2.KeyDown tk.escape?
            Free win2
            win2 ↩ @
        ;@}
    }win2
}•_while_{𝕊: ¬@‿@≡win1‿win2} @
