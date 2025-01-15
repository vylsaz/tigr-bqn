⟨Window, Time, Free, tk ⇐ key, tfont⟩ ← •Import "../../tigr.bqn"

screen ← "Shady" Window 320‿240
screen.SetPostShader "
void fxShader(out vec4 color, in vec2 uv) {
   vec2 tex_size = vec2(textureSize(image, 0));
   vec4 c = texture(image, (floor(uv * tex_size) + 0.5 * sin(parameters.x)) / tex_size);
   color = c;
}"

duration ← 1
phase ← 0
{𝕊:
    phase +↩ Time@
    {𝕊: phase -↩ duration}•_while_{𝕊: phase>duration}@
    p ← (6.28×phase)÷duration
    screen.SetPostFX ⟨p, 0, 0, 0⟩
    screen.Clear 128‿144‿160
    255‿255‿255 screen tfont._Print_"Shady business" 120‿110
    screen.Update@
}•_while_((¬ screen.Closed)∧(¬ screen.KeyDown⟜tk.escape))@
Free screen
