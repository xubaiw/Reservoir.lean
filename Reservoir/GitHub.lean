import Lean.Data.Json

open Lean Json

namespace Reservoir

/--
  Equip the monad with GitHub token.
-/
abbrev GitHubT := ReaderT String

/--
  Equip the `IO` monad with GitHub token.
-/
abbrev GitHubM := GitHubT IO

/--
  Search code on GitHub with the `query` string.
-/
def searchCode (query: String) : GitHubM (Array Json) := do
  let mut results := #[]
  for page in [1:11] do
    let res ← searchCodeOnePage query page
    if let Except.ok items := res.getObjValAs? (Array Json) "items" then
      results := results ++ items
  return results
  
  where
    -- auxiliary function to search one page
    searchCodeOnePage q p : GitHubM Json := do 
      let token ← read
      let out ← IO.Process.output {
        cmd := "curl"
        args :=
          #[
            "-s",
            "-H", s!"Authorization: token {token}",
            "--location", s!"https://api.github.com/search/code?q={q}&page={p}&per_page=100",
            "--header", "Accept: application/vnd.github.v3+json" 
          ]
      }
      if out.exitCode ≠ 0 then
        throw <| IO.Error.userError "curl failed"
      else
        match Json.parse out.stdout with
        | Except.ok res => return res
        | Except.error msg =>
          throw <| IO.Error.userError msg

end Reservoir