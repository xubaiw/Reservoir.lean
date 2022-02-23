import Lake
open Lake DSL

package Reservoir {
  binName := "reservoir"
  dependencies := #[{
    name := `«doc-gen4»
    src := Source.git "https://github.com/leanprover/doc-gen4" "28bb2abe40aef3bbaa4e4bc5855cd3d68b122a8e"
  }]
}
