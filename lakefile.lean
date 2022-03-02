import Lake
open Lake DSL

package Reservoir {
  binName := "reservoir"
  dependencies := #[
    {
      name := `«doc-gen4»
      src := Source.git "https://github.com/leanprover/doc-gen4" "6492f827b7f4af35b046b5b53c91b18a39b365d6"
    },
    {
      name := `Cli
      src := Source.git "https://github.com/mhuisi/lean4-cli.git" "1f8663e3dafdcc11ff476d74ef9b99ae5bdaedd3"
    }
  ]
}
