import DocGen4.ToHtmlFormat

open Lean IO System

namespace Reservoir

def gitClone (url : String) (path : FilePath) : IO Unit := do
  let out ← IO.Process.output {
    cmd := "git"
    args := #["clone", url, path.toString]
  }
  if out.exitCode ≠ 0 then
    throw <| IO.Error.userError "git clone failed"

end Reservoir