import DocGen4.ToHtmlFormat
import Lean.Data.Json
import Reservoir.Generate.Index
import Reservoir.Generate.Package
import Reservoir.Generate.Statics
import Reservoir.GitHub
import Std.Data.HashMap

open scoped DocGen4.Jsx

open Lean Json IO Std System

namespace Reservoir

/--
  Generate a site of Lean projects from the given repository full names.
-/
def generate (names : Array String) (output : FilePath) : IO Unit := do
  -- index
  let indexPath := output / "index.html"
  let indexPage := indexHtml names
  safeWrite indexPath indexPage.toString
  -- package
  for n in names do
    let packagePath := output / fullNameToRelativePath n
    let packagePage := packageHtml n
    safeWrite packagePath packagePage.toString
  -- statics
  for x in statics do
    let staticPath := output / x.fst
    safeWrite staticPath x.snd
  where
    safeWrite f t : IO Unit := do
      if let some par := f.parent then
        IO.FS.createDirAll par
      else
        panic! s!"Invalid to create parent dir for {f}"
      IO.FS.writeFile f t


end Reservoir