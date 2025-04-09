import Foundation

struct Letter: Codable, Hashable, Identifiable {
    let id: Int
    let letter: String
    let question: String
    let answer: String
    var status: Status
}
