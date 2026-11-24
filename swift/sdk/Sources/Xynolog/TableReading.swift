import Foundation

/// The table `file` of protocol/specs/src, its text `json`, read as its schema's model. A table its
/// model refuses is one the generator wrote wrong: it traps.
func readTable<Table: Decodable>(file: String, _ json: String) -> Table {
  do {
    return try JSONDecoder().decode(Table.self, from: Data(json.utf8))
  } catch {
    preconditionFailure("protocol/specs/src/\(file) is not its schema's model: \(error)")
  }
}
