# Reservoir.lean

WIP unofficial package registry of Lean 4.

## Index

The default index of Reservoir is [reservoir-index](https://github.com/xubaiw/reservoir-index), and a [rendered](https://xubaiw.github.io/reservoir-index/) version is served on GitHub Pages.

## Implementation

This is based on the GitHub Search API:

```sh
curl -s \
  -H "Authorization: token <YOUR TOKEN>" \
  --location "https://api.github.com/search/code?q=Lake&language:Lean" \
  --header "Accept: application/vnd.github.v3+json" 
```

Since SSL utilities for Lean 4 are not yet finished, this package requires the existence of commandline `curl`.
