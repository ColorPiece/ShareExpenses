import SwiftUI
import SwiftData

@main
struct ShareExpensesApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Data.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}

extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

struct appColor {
  static let bgColor: Color = Color(0xF6FAF6)
  static let letterColor: Color = Color(0x333333)
  static let smallLetterColor: Color = Color(0x889291)
  static let borderColor: Color = Color(0xE8E2D6)
  static let selectedColor: Color = Color(0x74C3C6)
  
  static let plusColor: Color = Color(0x7FA9D9)
  static let minusColor: Color = Color(0xEE869A)
}
