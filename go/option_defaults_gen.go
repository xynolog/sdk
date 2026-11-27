// Code generated from protocol/specs/src/client/option-defaults.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/option_defaults/go.ml)

package xynolog

import "github.com/xynolog/sdk/go/api"

// browseFilesDirPath is the directory listed: the knowledge base's root.
const browseFilesDirPath = "."

// browseFilesSort is how the listing is ordered: by name.
const browseFilesSort = api.BrowseDirectoryRequestSortName

// gatherResourceDepth is how many links out from the resource the graph
// reaches.
const gatherResourceDepth = 2

// gatherResourceMaxResources is the most resources the context holds.
const gatherResourceMaxResources = 10

// gatherResourceIncludeContent is whether the context carries the resources'
// text.
const gatherResourceIncludeContent = true

// gatherResourceIncludeSummary is whether the context carries a summary of
// the resource.
const gatherResourceIncludeSummary = false

// matchSearchLimit is the most candidates the search answers.
const matchSearchLimit = 10
