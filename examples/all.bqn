⟨ At, Exists, List, Parent ⟩ ← •file

{
    •Out "Running "∾•Fmt 𝕩
    ⟨ "test" ⟩ •Import 𝕩
}¨(⊢/˜Exists¨)(< At⟜{𝕩 At 𝕩∾".bqn"}¨List) •path
