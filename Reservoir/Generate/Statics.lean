import DocGen4.IncludeStr
import Lean.Data.Json
import Reservoir.GitHub
import Std.Data.HashMap

open Lean Json IO Std System

namespace Reservoir

def styleCss := include_str "../../static/style.css"
def indexNavigateJs := include_str "../../static/index-navigate.js"

def statics : Array (FilePath × String) := #[
  ("./static/style.css", styleCss),
  ("./static/index-navigate.js", indexNavigateJs)
]

end Reservoir