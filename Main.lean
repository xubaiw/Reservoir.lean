import Reservoir

def main (args : List String) : IO Unit := do
  if let some path := args.get? 0 then
    let res ← Reservoir.search
    let html := Reservoir.jsonArrToHtml res
    IO.FS.writeFile path html.toString
  else
    IO.println "Usage: reservoir <path>"