import Foundation
import SwiftData

@Model
final class Data {
  @Attribute(.unique)
  var id: UUID
  var mode: String
  var price: String
  var unit: String
  var category: String
  var date: Date
  var note: String

  init(mode: String, price: String, unit: String, category: String, date: Date, note: String) {
    self.id = UUID()
    self.mode = mode
    self.price = price
    self.unit = unit
    self.category = category
    self.date = date
    self.note = note
  }
}
