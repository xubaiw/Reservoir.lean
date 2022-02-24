import DocGen4.ToHtmlFormat
import Lean.Data.Json
import Reservoir.GitHub
import Std.Data.HashMap

open scoped DocGen4.Jsx

open Lean Json IO Std System DocGen4

namespace Reservoir

def templateHtml (title : String) (contents : Array Html) : Html := 
  <html>
    <head>
      <meta charset="utf-8"/>

      <title>{title}</title>
      
      <link rel="stylesheet" href="./static/style.css" />

    </head>
    <body>
      <header>
        <h1><a href="./">Reservoir</a></h1>
        <input placeholder="Text in here to navigate!" />
        <ul>
          <li>
            <a href="#">About</a>
          </li>
          <li>
            <a href="#">New</a>
          </li>
          <li>
            <a href="#">Trending</a>
          </li>
        </ul>
      </header>
      <main>
        [contents]
      </main>
    </body>
  </html>

end Reservoir