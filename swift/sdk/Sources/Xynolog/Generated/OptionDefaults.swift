// Generated from protocol/specs/src/client/option-defaults.json; do not edit.
// Regenerate: make generate (codegen/lib/option_defaults/swift.ml)
import Foundation

/// What a public option of the client is when its caller leaves it out, where the client decides it.
public enum OptionDefaults {
  /// The directory listed: the knowledge base's root.
  public static let browseFilesDirPath: String = "."
  /// How the listing is ordered: by name.
  public static let browseFilesSort: BrowseDirectoryRequestSort = .name
  /// How many links out from the resource the graph reaches.
  public static let gatherResourceDepth: Int = 2
  /// The most resources the context holds.
  public static let gatherResourceMaxResources: Int = 10
  /// Whether the context carries the resources' text.
  public static let gatherResourceIncludeContent: Bool = true
  /// Whether the context carries a summary of the resource.
  public static let gatherResourceIncludeSummary: Bool = false
  /// The most candidates the search answers.
  public static let matchSearchLimit: Int = 10
  /// Whether a session opened over a kept sign-in asks the gateway who its token is.
  public static let keptSignInSessionFromKeptValidate: Bool = true
}
