import Lean.Data.Json
import Reservoir.GitHub

open Lean Json IO

namespace Reservoir

/--
  Search for Lean packages on GitHub.
-/
def prospect : GitHubM (Array String) := do
  let query := "language:lean+Lake"
  let js ← searchCode query
  return js.filterMap 
    λ j => j.getObjVal? "repository"
      |>.bind (·.getObjValAs? String "full_name")
      |>.toOption

end Reservoir