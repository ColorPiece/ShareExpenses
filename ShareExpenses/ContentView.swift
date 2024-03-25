import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Data.date, order: .reverse) private var datas: [Data]
  
  let userDefaults = UserDefaults.standard
  @State private var modes: [String] = ["Expense", "Income"]
  @State private var units: [String] = []
  @State private var categoriesExpense: [String] = []
  @State private var categoriesIncome: [String] = []

  @State private var initFlag: Bool = false  
  @State private var selection = 1

  var body: some View {
    TabView(selection: $selection) {
      InputView(modes: $modes, units: $units, categoriesExpense: $categoriesExpense, categoriesIncome: $categoriesIncome)
        .tabItem {
          Label("Input", systemImage: "pencil")
        }
        .tag(1)
      CalendarView(modes: $modes, units: $units)
        .tabItem {
          Label("Calendar", systemImage: "calendar")
        }
        .tag(2)
      SettingView(units: $units, categoriesExpense: $categoriesExpense, categoriesIncome: $categoriesIncome)
        .tabItem {
          Label("Setting", systemImage: "gear")
        }
        .tag(3)
    }
    .onAppear {
      if initFlag == false {
        initFlag = true
        units = userDefaults.array(forKey: "Unit") as? [String] ?? []
        categoriesExpense = userDefaults.array(forKey: "Expense") as? [String] ?? []
        categoriesIncome = userDefaults.array(forKey: "Income") as? [String] ?? []
      }
    }
  }
}
