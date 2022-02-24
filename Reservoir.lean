import DocGen4.ToHtmlFormat
import Lean.Data.Json
import Reservoir.Cli

open Lean Json
open scoped DocGen4.Jsx

namespace Reservoir

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