import Lean.Data.Json
import Lean.Data.Xml

open Lean Json System Xml

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
  Turn GitHub repository full name into relative path.
-/
def fullNameToRelativePath (n : String) : FilePath := 
  ⟨ "./" ++ n.replace "/" "." ++ ".html" ⟩ 

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
        throw <| IO.Error.userError s!"curl failed: {out.stderr} {out.stderr}"
      else
        match Json.parse out.stdout with
        | Except.ok res => return res
        | Except.error msg =>
          throw <| IO.Error.userError msg

partial def removeGitHubLink (s : String) : String :=
  -- use XML to remove it
  if let Except.ok xml := Xml.parse s then
    traverse xml |> toString
  else
    s
  where
    traverse (x : Element) : Element := match x with
    | Element.Element name attrs contents => 
      let (newName, removeLink) := match name with
      | "h1" => ("h3", true)
      | "h2" => ("h4", true)
      | "h3" => ("h5", true)
      | "h4" => ("h6", true)
      | "h5" => ("b", true)
      | "h6" => ("em", true)
      | _ => (name, false)
      Element.Element newName attrs <| contents.map (traverseContent removeLink)
    traverseContent (removeLink : Bool) (c : Content) : Content := match c with
    | Content.Element e =>
      if removeLink ∧ (getName e = "a") then
        Content.Character ""
      else
        Content.Element <| traverse e
    | _ => c
    getName (x : Element) : String := match x with
    | Element.Element name _ _ => name

/--
  Get repository README.
-/
def getReadme (repo: String) : GitHubM String := do
  let token ← read
  let out ← IO.Process.output {
    cmd := "curl"
    args :=
      #[
        "-s",
        "-H", s!"Authorization: token {token}",
        "--location", s!"https://api.github.com/repos/{repo}/readme",
        "--header", "Accept: application/vnd.github.v3.html" 
      ]
  }
  if out.exitCode ≠ 0 then
    throw <| IO.Error.userError s!"curl failed: {out.stderr} {out.stderr}"
  else
    return removeGitHubLink out.stdout

/--
  Get repository description.
-/
def getDescription (repo: String) : GitHubM String := do
  let token ← read
  let out ← IO.Process.output {
    cmd := "curl"
    args :=
      #[
        "-s",
        "-H", s!"Authorization: token {token}",
        "--location", s!"https://api.github.com/repos/{repo}",
        "--header", "Accept: application/vnd.github.v3+json" 
      ]
  }
  if out.exitCode ≠ 0 then
    throw <| IO.Error.userError s!"curl failed: {out.stderr} {out.stderr}"
  else
    match Json.parse out.stdout |>.bind (·.getObjValAs? String "description") with
    | Except.ok res => return res
    | Except.error msg => return "None Description"

end Reservoir