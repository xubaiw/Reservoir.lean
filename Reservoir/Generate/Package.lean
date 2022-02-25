import DocGen4.ToHtmlFormat
import Lean.Data.Json
import Reservoir.Generate.Template
import Reservoir.GitHub
import Std.Data.HashMap

open scoped DocGen4.Jsx

open Lean Json IO Std System

namespace Reservoir

def packageHtml (name description readme : String) : DocGen4.Html := 
  let contents := #[
    <h1>{DocGen4.Html.text name}</h1>,
    <p>{description}</p>,
    <a href={s!"https://github.com/{name}"}>GitHub Link</a>,
    <a href="#" title="Missing now!">Documentation</a>,
    <h2>Pick a version!</h2>,
    <p>{"TODO: should show a time axes that allows the users to view, filter and click copy the lakefile config."}</p>,
    <h2>README</h2>,
    readme
  ]
  templateHtml name contents

end Reservoir