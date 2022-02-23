# Reservoir.lean

WIP unofficial package registry of Lean 4.

This is based on the GitHub Search API:

```sh
curl -s \
  -H "Authorization: token <YOUR TOKEN>" \
  --location "https://api.github.com/search/code?q=Lake&language:Lean" \
  --header "Accept: application/vnd.github.v3+json" 
```

Since SSL utilities for Lean 4 are not yet finished, this package requires the existence of commandline `curl`.
