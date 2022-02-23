import Reservoir

open System Reservoir

def main (args : List String) : IO Unit := do
  match args.get? 0, args.get? 1 with
  | some token, some path =>
    let res ← search token
    let html := jsonArrToHtml res
    IO.FS.createDirAll <| Option.get! <| FilePath.parent <| FilePath.mk path
    IO.FS.writeFile path html.toString
  | _, _ =>
    IO.println "Usage: reservoir <token> <path>"