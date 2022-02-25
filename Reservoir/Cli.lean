import Cli
import Lean.Data.Json
import Reservoir.Generate
import Reservoir.Prospect
import Std.Data.HashSet

open System Reservoir Cli Lean Json Std

namespace Reservoir

/--
  Get GitHub token either from flags provided or from environment variable `GITHUB_TOKEN`.
-/
def getToken! (p : Parsed) : IO String := do
  if let some t := p.flag? "token" |>.bind (·.as? String) then
    return t
  else
    if let some t ← IO.getEnv "GITHUB_TOKEN" then
      return t
    else
      panic!  "Neither `--token` nor `GITHUB_TOKEN` is given."
    
/--
  Load indices data from file.
-/
def loadIndicesFromFile (p : Parsed) : IO (Array String) := do
  if let some f := p.flag? "input" |>.bind (·.as? String) then
    let s ← IO.FS.readFile f
    if let some res := Json.parse s |>.bind fromJson? |>.toOption then
      return res
    else 
      panic! "Invalid input file."
  else
    return #[]

/--
  Command runner for the `Reservoir.prospect`.
-/
def runProspectCmd (p : Parsed) : IO UInt32 := do
  let token ← getToken! p
  let oldIndices ← loadIndicesFromFile p
  let newFoundIndices ← ReaderT.run prospect token
  let res := (oldIndices ++ newFoundIndices)
    |>.foldl (λ h s => h.insert s) HashSet.empty
    |>.toArray |>.qsort (· < ·) |> toJson |> toString
  let output? := p.flag? "output" |>.bind (·.as? String) |>.map λ s => (System.FilePath.mk s)
  match output? with
  | some f => do
    if let some par := f.parent then
      IO.FS.createDirAll par
    IO.FS.writeFile f res
  | none => 
    IO.println res
  return 0

/--
  Command for running `Reservoir.prospect`.
-/
def prospectCmd := `[Cli|
  prospect VIA runProspectCmd; ["0.0.1"]
  "Search for new Lean packages on GitHub."

  FLAGS:
    i, input : String;   "Path of the old package index file. This flag is optioanl."
    o, output : String;  "Path to output new package index file. If not provided, the result will print to stdout."
    t, token : String;   "GitHub access token. If not provided, the command will try to find the `GITHUB_TOKEN` environment variable. If both not provided, the command fails."
]

/--
  Command runner for the `Reservoir.generate`.
-/
def runGenerateCmd (p : Parsed) : IO UInt32 := do
  let token ← getToken! p
  let indices ← loadIndicesFromFile p
  if let some output := p.flag? "output" |>.bind (·.as? String) |>.map λ s => (System.FilePath.mk s) then
    discard <| ReaderT.run (generate indices output) token
  else 
    panic! "A output directory must be specified."
  return 0

/--
  Command for running `Reservoir.generate`.
-/
def generateCmd := `[Cli|
  generate VIA runGenerateCmd; ["0.0.1"]
  "Generate a site of Lean projects from the given indices."

  FLAGS:
    i, input : String;   "Path of the package indiex file."
    o, output : String;  "Path to output all generated files."
]

/--
   Command runner for the whole program
-/
def runReservoirCmd (p : Parsed) : IO UInt32 := do
  IO.println "Run `reservoir -h` for help."
  return 0

/--
  Command for running the whole program.
-/
def reservoirCmd := `[Cli|
  reservoir VIA runReservoirCmd; ["0.0.1"]
  "Reservoir for indexing Lean packages!"

  SUBCOMMANDS:
    prospectCmd;
    generateCmd
]

end Reservoir