import SwiftUI

struct SettingView: View {
  @Binding var units: [String]
  @Binding var categoriesExpense: [String]
  @Binding var categoriesIncome: [String]

  var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Unit")) {
          NavigationLink("Unit") {
            SettingDetailView(units: $units, categoriesExpense: $categoriesExpense, categoriesIncome: $categoriesIncome, key: "Unit")
          }
        }
        Section(header: Text("Category")) {
          NavigationLink("Expense") {
            SettingDetailView(units: $units, categoriesExpense: $categoriesExpense, categoriesIncome: $categoriesIncome, key: "Expense")
          }
          NavigationLink("Income") {
            SettingDetailView(units: $units, categoriesExpense: $categoriesExpense, categoriesIncome: $categoriesIncome, key: "Income")
          }
        }
      }
      .navigationTitle("Setting")
    }
  }
}
