import Lean.Data.Json
import DocGen4.ToHtmlFormat

open Lean Json
open scoped DocGen4.Jsx

namespace Reservoir

def searchAux (page : Nat) : IO Json := do
  let out ← IO.Process.output {
    cmd := "curl"
    args :=
      #[
        "-s",
        "-H", "Authorization: token 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",
        "--location", s!"https://api.github.com/search/code?q=Lake+language:Lean&sort=index&page={page}&per_page=100",
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

def search : IO (Array Json) := do
  let mut results := #[]
  for p in [1:11] do
    let res ← searchAux p
    if let Except.ok items := res.getObjValAs? (Array Json) "items" then
      results := results ++ items
  return results

def jsonArrToHtml (js : Array Json) : DocGen4.Html := Id.run <| do
  let mut projects := Std.HashMap.empty
  for j in js do
    if let Except.ok repo := j.getObjValAs? Json "repository" then
      let fullName? := repo.getObjValAs? String "full_name" 
      let htmlUrl? := repo.getObjValAs? String "html_url"
      match fullName?, htmlUrl? with
      | Except.ok fullName , Except.ok htmlUrl => projects := projects.insert fullName htmlUrl
      | _, _ => ()
  let htmls := projects.fold (λ acc k v => acc.push <li><a href={v}>{k}</a></li>) #[]
  pure
    <html>
      <head>
        <title>Reservoir.lean</title>
      </head>
      <body>
        <h1>Reservoir</h1>
        <p>The following is a list of Lean 4 projects:</p>
        <ul>
          [htmls]
        </ul>
      </body>
    </html>