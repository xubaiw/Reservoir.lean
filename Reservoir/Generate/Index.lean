import DocGen4.ToHtmlFormat
import Lean.Data.Json
import Reservoir.Generate.Template
import Reservoir.GitHub
import Std.Data.HashMap

open scoped DocGen4.Jsx

open Lean Json IO Std System

namespace Reservoir

def indexHtml (names : Array String) : DocGen4.Html := 
  let contents := #[
    <p>The following is an incomplete list of Lean 4 projects:</p>,
    <ul>
      [
        names.map λ i =>
          <li>
            <a href={toString $ fullNameToRelativePath i}>
              {
                DocGen4.Html.text i
              }
            </a>
          </li>
      ]
    </ul>,
    <script defer="true" src="./static/index-navigate.js"></script>
  ]
  templateHtml "Index" contents

end Reservoir