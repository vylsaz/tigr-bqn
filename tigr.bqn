void ← {t ⇐ ""}
char ← {t ⇐ "i8:c8"}
u8   ← {t ⇐ "u8"}
i8   ← {t ⇐ "i8"}
i32  ← {t ⇐ "i32"}
u64  ← {t ⇐ "u64"}
f32  ← {t ⇐ "f32"}
f64  ← {t ⇐ "f64"}
Ptr  ← {t ⇐ "*"∾𝕩.t}
Out  ← {t ⇐ "&"∾𝕩.t}
Array ← {n ⇐ 𝕨, t ⇐ "["∾(•Fmt 𝕨)∾"]"∾𝕩.t}
Struct ← {𝕊 defs:
    [membs, types] ← ⍉>defs
    f ⇐ membs
    t ⇐ "{"∾"}"∾˜¯1↓∾{𝕩.t∾","}¨types
    Of ⇐ {o ← ⊑f⊐<𝕩, ("no field "∾•Fmt 𝕩)!o<≠f, o}
}

asI8 ← {t ⇐ ":i8"}
ptrSz ← 8
null ← ptrSz⥊0

Of ← ⋈

NewEnum ← {𝕊:
    {
        x ← 0, f ← {⊢}
        I ⇐ {𝕊: y ← x, x +↩ 1, F y}
        Set ⇐ {x ↩ 𝕩, f ↩ {⊢}, I @}
        _setf ⇐ {x ↩ 𝕩, f ↩ 𝕗, I @}
    }
}

_ffiWith_ ← {
    𝔽 _𝕣_ 𝔾 𝕩: {t ⇐ "&"} 𝕊 𝕩; 
    n ← @≡𝕩
    s ← 0==𝕩
    r ← 𝕘 •FFI ⟨𝕨.t, 𝕗⟩∾{
        n? ⟨⟩;
        s? ⟨">"∾𝕩.t⟩; 
        {𝕩.t}¨𝕩
    }𝕩
    {
        n? {𝕊: R ⟨⟩}; 
        r
    }
}

tigrdll ← ({⟨⟩: ""; ⊑𝕩}•args)•file.At{
    "windows": "tigr.dll";
    "darwin": "libtigr.dylib";
    "libtigr.so"
}•platform.os
_ffi ⇐ {𝔽 _ffiWith_ tigrdll}


tPixel ← Struct ⟨"r", "g", "b", "a"⟩Of¨u8

Pixel ← {4↑𝕩∾<255}

ToUpper ← {('A'⊸+-⟜'a')⌾((('a'⊸≤∧≤⟜'z')𝕩)⊸/) 𝕩}
h ← "0123456789ABCDEF"
Hex2 ← {!∧´16>n ← h⊐ ToUpper 𝕩, +´16‿1×2⥊n}

Hex ⇐ {𝕊⁼ 𝕩: "#"∾⥊⊏⟜h˘⍉16(⌊∘÷˜≍|)𝕩;
𝕊 h:
    Hex2˘h⥊˜{
        8: 4‿2; 4: 4‿1;
        6: 3‿2; 3: 3‿1;
        !"wrong length: "∾•Fmt h
    }≠h ↓˜↩ '#'≡⊑h
}

# tigr ⇐ Struct ⟨
#     "w"Of i32, "h"Of i32
#     "cx"Of i32, "cy"Of i32, "cw"Of i32, "ch"Of i32
#     "pix"Of Ptr tPixel
#     "handle"Of Ptr void
#     "blitMode"Of i32
# ⟩
tigr ← asI8
tigrOffset ← {
    w ⇐ 0
    h ⇐ 4
    cx ⇐ 8
    cy ⇐ 12
    cw ⇐ 16
    ch ⇐ 20
    pix ⇐ 24
    handle ⇐ 32
    blitMode ⇐ 40
}

flag ⇐ {
    fixed ⇐ 0
    e ← NewEnum@
    auto  ⇐ 2⊸⋆e._setf 0
    scale2x ⇐ e.I@
    scale3x ⇐ e.I@
    scale4x ⇐ e.I@
    retina ⇐ e.I@
    noCursor ⇐ e.I@
    fullscreen ⇐ e.I@
}

keepAlpha  ← 0
blendAlpha ← 1

tigrGlyph ← Struct ⟨"code", "x", "y", "w", "h"⟩Of¨i32

tigrFont ← Struct ⟨
    "bitmap"Of Ptr tigr
    "numGlyphs"Of i32
    "glyphs"Of Ptr tigrGlyph
⟩

codepage ⇐ {
    ascii   ⇐ 0
    cp_1252 ⇐ 1252
    utf32   ⇐ 12001
}

key ⇐ {e ← NewEnum@
    pad0 ⇐ e.Set 128
    pad1 ⇐ e.I@
    pad2 ⇐ e.I@
    pad3 ⇐ e.I@
    pad4 ⇐ e.I@
    pad5 ⇐ e.I@
    pad6 ⇐ e.I@
    pad7 ⇐ e.I@
    pad8 ⇐ e.I@
    pad9 ⇐ e.I@

    padmul ⇐ e.I@
    padadd ⇐ e.I@
    padenter ⇐ e.I@
    padsub ⇐ e.I@
    paddot ⇐ e.I@
    paddiv ⇐ e.I@

    f1 ⇐ e.I@
    f2 ⇐ e.I@
    f3 ⇐ e.I@
    f4 ⇐ e.I@
    f5 ⇐ e.I@
    f6 ⇐ e.I@
    f7 ⇐ e.I@
    f8 ⇐ e.I@
    f9 ⇐ e.I@
    f10 ⇐ e.I@
    f11 ⇐ e.I@
    f12 ⇐ e.I@

    backspace ⇐ e.I@
    tab ⇐ e.I@
    return ⇐ e.I@
    shift ⇐ e.I@
    control ⇐ e.I@
    alt ⇐ e.I@
    pause ⇐ e.I@
    capslock ⇐ e.I@

    escape ⇐ e.I@
    space ⇐ e.I@
    pageup ⇐ e.I@
    pagedn ⇐ e.I@
    end ⇐ e.I@
    home ⇐ e.I@
    left ⇐ e.I@
    up ⇐ e.I@
    right ⇐ e.I@
    down ⇐ e.I@

    insert ⇐ e.I@
    delete ⇐ e.I@
    lwin ⇐ e.I@
    rwin ⇐ e.I@
    numlock ⇐ e.I@
    scroll ⇐ e.I@
    lshift ⇐ e.I@
    rshift ⇐ e.I@

    lcontrol ⇐ e.I@
    rcontrol ⇐ e.I@
    lalt ⇐ e.I@
    ralt ⇐ e.I@
    semicolon ⇐ e.I@
    equals ⇐ e.I@
    comma ⇐ e.I@
    minus ⇐ e.I@

    dot ⇐ e.I@
    slash ⇐ e.I@
    backtick ⇐ e.I@
    lsquare ⇐ e.I@
    backslash ⇐ e.I@
    rsquare ⇐ e.I@
    tick ⇐ e.I@
}


c ← {
bmp ← Ptr tigr
window ⇐ bmp  "tigrWindow"_ffi⟨i32, i32, Ptr char, i32⟩
bitmap ⇐ bmp  "tigrBitmap"_ffi⟨i32, i32⟩
free   ⇐ void "tigrFree"  _ffi bmp
closed ⇐ i32  "tigrClosed"_ffi bmp
update ⇐ void "tigrUpdate"_ffi bmp
beginOpenGL ⇐ i32 "tigrBeginOpenGL"_ffi bmp
setPostShader ⇐ void "tigrSetPostShader"_ffi⟨bmp, Ptr char, i32⟩
setPostFX ⇐ void "tigrSetPostFX"_ffi⟨bmp, f32, f32, f32, f32⟩

get   ⇐ tPixel "tigrGet"_ffi⟨bmp, i32, i32⟩
plot  ⇐ void  "tigrPlot"_ffi⟨bmp, i32, i32, tPixel⟩
clear ⇐ void "tigrClear"_ffi⟨bmp, tPixel⟩
fill  ⇐ void  "tigrFill"_ffi⟨bmp, i32, i32, i32, i32, tPixel⟩
line  ⇐ void  "tigrLine"_ffi⟨bmp, i32, i32, i32, i32, tPixel⟩
rect     ⇐ void     "tigrRect"_ffi⟨bmp, i32, i32, i32, i32, tPixel⟩
fillRect ⇐ void "tigrFillRect"_ffi⟨bmp, i32, i32, i32, i32, tPixel⟩
circle     ⇐ void     "tigrCircle"_ffi⟨bmp, i32, i32, i32, tPixel⟩
fillCircle ⇐ void "tigrFillCircle"_ffi⟨bmp, i32, i32, i32, tPixel⟩
clip ⇐ void "tigrClip"_ffi⟨bmp, i32, i32, i32, i32⟩
blit      ⇐ void "tigrBlit"     _ffi⟨bmp, bmp, i32, i32, i32, i32, i32, i32⟩
blitAlpha ⇐ void "tigrBlitAlpha"_ffi⟨bmp, bmp, i32, i32, i32, i32, i32, i32, f32⟩
blitTint  ⇐ void "tigrBlitTint" _ffi⟨bmp, bmp, i32, i32, i32, i32, i32, i32, tPixel⟩
blitMode  ⇐ void "tigrBlitMode" _ffi⟨bmp, i32⟩

font ⇐ Ptr tigrFont
loadFont ⇐ font "tigrLoadFont"_ffi⟨bmp, i32⟩
freeFont ⇐ void "tigrFreeFont"_ffi font
print ⇐ void "tigrPrint"_ffi⟨bmp, font, i32, i32, tPixel, Ptr char, Ptr char⟩
textWidth  ⇐ i32 "tigrTextWidth" _ffi⟨font, Ptr char⟩
textHeight ⇐ i32 "tigrTextHeight"_ffi⟨font, Ptr char⟩

mouse ⇐ void "tigrMouse"_ffi⟨bmp, Out i32, Out i32, Out i32⟩

scrollWheel ⇐ void "tigrScrollWheel"_ffi⟨bmp, Out f32, Out f32⟩

keyDown ⇐ i32 "tigrKeyDown"_ffi⟨bmp, i32⟩
keyHeld ⇐ i32 "tigrKeyHeld"_ffi⟨bmp, i32⟩
readChar ⇐ i32 "tigrReadChar"_ffi bmp

loadImage    ⇐ bmp "tigrLoadImage"   _ffi Ptr char
loadImageMem ⇐ bmp "tigrLoadImageMem"_ffi⟨Ptr char, i32⟩
saveImage ⇐ i32 "tigrSaveImage"_ffi⟨Ptr char, bmp⟩

time ⇐ f32 "tigrTime"_ffi @

error ⇐ void "tigrError"_ffi⟨bmp, Ptr char, Ptr char⟩
}

Time ⇐ c.Time

ToCstr ← {(•ToUTF8 𝕩)∾@}

memcpyI32 ← "memcpy"_ffiWith_@ ⟨Out i32, Ptr asI8, u64⟩
memcpyI8 ← "memcpy"_ffiWith_@ ⟨Out i8, Ptr asI8, u64⟩
memcpyPixel ← "memcpy"_ffiWith_@ ⟨Out tPixel, Ptr asI8, u64⟩

# From
# https://github.com/mlochbaum/bqn-libs/blob/master/bignat.bqn
base ← 2⋆8
Carry ← {
    b ← 𝕨 ⊣ 0           # Carry in
    g ← 𝕩 ≥ base        # Generate
    p ← 𝕩 = base-1      # Propagate
    i ← ⌈`∘×⟜(1+↕∘≠)¬p  # Start index of propagation chain
    a ← i ⊏ gs←b∾g      # Active propagations
    c ← g ∨ p ∧ a       # Carry from these positions
    r ← (𝕩 + b»c) - c×base
    ⟨r, c⊸«⌾⋈b⟩
}
_extend ← { 𝕨 𝔽○((𝕨⌈○≠𝕩)⊸↑) 𝕩 }
Add ← { 0⊸<◶⊣‿∾´ Carry 𝕨 +_extend 𝕩 }

Offset ← {⟨ 8‿'c', 8‿'i' ⟩•bit._cast @+ 𝕨 Add base|𝕩}

MakeBmp ← {𝕊 bmp:
    !bmp ≢ null
    {
        bmp ⇐ bmp
        W ⇐ {𝕊: ⊑MemcpyI32 ⟨<0, tigrOffset.w Offset bmp, 4⟩}
        H ⇐ {𝕊: ⊑MemcpyI32 ⟨<0, tigrOffset.h Offset bmp, 4⟩}
        Size ⇐ {𝕊: ⟨W@, H@⟩}
        Pix ⇐ {𝕊:
            ptr ← MemcpyI8 ⟨null, tigrOffset.pix Offset bmp, ptrSz⟩
            w‿h ← Size @
            h‿w⥊MemcpyPixel ⟨h‿w⥊<4⥊0, ptr, w×h×4⟩
        }

        Closed ⇐ {𝕊: 0≠c.Closed bmp}
        Update ⇐ {𝕊: c.Update bmp}

        BeginOpenGL ⇐ {𝕊: 0≠c.BeginOpenGL bmp}
        SetPostShader ⇐ {
            s ← •ToUTF8 𝕩
            c.SetPostShader⟨bmp, s∾@, ≠s⟩
        }
        SetPostFX ⇐ {c.SetPostFX⟨bmp⟩∾𝕩}

        Get ⇐ {c.Get⟨bmp⟩∾𝕩}
        Plot ⇐ {c.Plot⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        Clear ⇐ {c.Clear⟨bmp, Pixel 𝕩⟩}
        Fill ⇐ {c.Fill⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        Line ⇐ {c.Line⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        Rect     ⇐ {c.Rect⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        FillRect ⇐ {c.FillRect⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        Circle     ⇐ {c.Circle⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        FillCircle ⇐ {c.FillCircle⟨bmp⟩∾𝕩∾<Pixel 𝕨}
        Clip ⇐ {c.Clip⟨bmp⟩∾𝕩}

        BlitKeepAlpha  ⇐ {𝕊: c.BlitMode⟨bmp, keepAlpha⟩}
        BlitBlendAlpha ⇐ {𝕊: c.BlitMode⟨bmp, blendAlpha⟩}

        Mouse ⇐ {𝕊: ⊑¨c.Mouse⟨bmp, <0, <0, <0⟩}
        ScrollWheel ⇐ {𝕊: ⊑¨c.ScrollWheel⟨bmp, <0, <0⟩}
        KeyDown ⇐ {
            2=•Type 𝕩? 𝕊 𝕩-@;
            0≠c.KeyDown⟨bmp, 𝕩⟩
        }
        KeyHeld ⇐ {
            2=•Type 𝕩? 𝕊 𝕩-@;
            0≠c.KeyHeld⟨bmp, 𝕩⟩
        }
        ReadChar ⇐ {𝕊: @+c.ReadChar bmp}

        SaveImage ⇐ {0≠c.SaveImage⟨ToCstr 𝕩, bmp⟩}

        Error ⇐ {c.Error⟨bmp, ToCstr"%s", ToCstr 𝕩⟩}
    }
}
Free ⇐ {c.Free 𝕩.bmp}

_WindowWithFlag ⇐ {title Flag _𝕣 size:
    MakeBmp c.Window size∾⟨ToCstr title, flag⟩
}
Window ⇐ {𝕨 0 _WindowWithFlag 𝕩}
_WithWindow_ ⇐ {𝔽 _𝕣_ 𝔾 𝕩: 0 𝕊 𝕩;
flag Func _𝕣_ Title size:
    w ← MakeBmp c.Window size∾⟨ToCstr title, flag⟩
    r ← (Func W) •_while_((¬ w.Closed)∧(¬ w.KeyDown⟜key.escape)) @
    Free w, r
}

Bitmap ⇐ {𝕊 size:
    MakeBmp c.Bitmap size
}
LoadImage ⇐ {𝕊 name:
    MakeBmp c.LoadImage ToCstr name
}
LoadImageMem ⇐ {𝕊 mem:
    MakeBmp c.LoadImageMem⟨mem, ≠mem⟩
}

LoadFont ⇐ {cp 𝕊 bmp:
    f ← c.LoadFont⟨bmp.bmp, cp⟩
    {
        f ⇐ f
        _Print_ ⇐ {color Bmp _𝕣_ Msg coord:
            c.Print⟨bmp.bmp, f⟩∾coord∾⟨Pixel color, ToCstr"%s", ToCstr msg⟩
        }
        TextWidth  ⇐ {c.TextWidth ⟨f, ToCstr 𝕩⟩}
        TextHeight ⇐ {c.TextHeight⟨f, ToCstr 𝕩⟩}
        TextSize ⇐ TextWidth∾TextHeight
    }    
}
FreeFont ⇐ {c.FreeFont 𝕩.f}

_Blit_ ⇐ {
dstCoord Dst _𝕣_ Src‿Size srcCoord:
    c.Blit⟨dst.bmp, src.bmp⟩∾dstCoord∾srcCoord∾size;
dstCoord Dst _𝕣_ Src srcCoord:
    dstCoord Dst _𝕣_⟨Src, src.Size@⟩ srcCoord
}
_BlitAlpha_ ⇐ {
dstCoord Dst _𝕣_ Src‿Size‿Alpha srcCoord:
    c.BlitAlpha⟨dst.bmp, src.bmp⟩∾dstCoord∾srcCoord∾size∾<alpha;
dstCoord Dst _𝕣_ Src‿Alpha srcCoord:
    dstCoord Dst _𝕣_⟨Src, src.Size@, Alpha⟩ srcCoord
}
_BlitTint_ ⇐ {
dstCoord Dst _𝕣_ Src‿Size‿Tint srcCoord:
    c.BlitTint⟨dst.bmp, src.bmp⟩∾dstCoord∾srcCoord∾size∾<tint;
dstCoord Dst _𝕣_ Src‿Tint srcCoord:
    dstCoord Dst _𝕣_⟨Src, src.Size@, Tint⟩ srcCoord
}

tfont ⇐ {
    handle ← Ptr void
    p ← {
    "windows":
        dll ← ToCstr {'\'¨⌾(('/'=𝕩)⊸/)𝕩}tigrdll
        getModuleHandleA ← handle "GetModuleHandleA"_ffiWith_@ Ptr char
        getProcAddress ← (Ptr c.font) "GetProcAddress"_ffiWith_@ ⟨handle, Ptr char⟩
        GetProcAddress ⟨GetModuleHandleA dll, ToCstr"tfont"⟩
    ;
        rtld_now ← 2
        dlopen ← handle "dlopen"_ffiWith_@ ⟨Ptr char, i32⟩
        dlsym ← (Ptr c.font) "dlsym"_ffiWith_@ ⟨handle, Ptr char⟩
        DlSym⟨DlOpen⟨ToCstr tigrdll, rtld_now⟩, ToCstr"tfont"⟩
    }•platform.os
    f ← p.Read 0
    {
        _Print_ ⇐ {color Bmp _𝕣_ Msg coord:
            c.Print⟨bmp.bmp, f⟩∾coord∾⟨Pixel color, ToCstr"%s", ToCstr msg⟩
        }
        TextWidth  ⇐ {c.TextWidth ⟨f, ToCstr 𝕩⟩}
        TextHeight ⇐ {c.TextHeight⟨f, ToCstr 𝕩⟩}
        TextSize ⇐ TextWidth∾TextHeight
    }
}
