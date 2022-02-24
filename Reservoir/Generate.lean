import DocGen4.ToHtmlFormat
import Lean.Data.Json
import Reservoir.GitHub
import Std.Data.HashMap

open scoped DocGen4.Jsx

open Lean Json IO Std System


namespace Reservoir

/--
  Generate a site of Lean projects from the given indices.
-/
def generate (indices : Array String) : HashMap FilePath String := 
  let indexPage :=
    <html>
      <head>
        <title>Reservoir.lean</title>
      </head>
      <body>
        <h1>Reservoir</h1>
        <p>The following is a noncomplete list of Lean 4 projects:</p>
        <ul>
          [
            indices.map fun i =>
              <li>
                <a href={"https://github.com/" ++ i}>{i}</a>
              </li>
          ]
        </ul>
      </body>
    </html>
  HashMap.empty.insert "index.html" indexPage.toString

end Reservoir