import SwiftUI

struct SettingDetailView: View {
  let userDefaults = UserDefaults.standard
  @Binding var units: [String]
  @Binding var categoriesExpense: [String]
  @Binding var categoriesIncome: [String]

  @State private var items: [String] = []

  @State private var isPresented: Bool = false
  @State private var newItem: String = ""

  let key: String

  var body: some View {
    List {
      ForEach(items, id: \.self) { item in
        Text(item)
      }
      .onDelete(perform: { indexSet in
        items.remove(atOffsets: indexSet)
        saveUserDefaults()
      })
      .onMove(perform: { indices, newOffset in
        items.move(fromOffsets: indices, toOffset: newOffset)
        saveUserDefaults()
      })
    }
    .navigationBarTitle(key, displayMode: .inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        EditButton()
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: {
          isPresented = true
        }, label: {
          Text("Add")
        })
        .alert("Add New \(key)", isPresented: $isPresented) {
          TextField("Type New \(key)", text: $newItem)
          Button(role: .cancel) {
            //print ("Cancel")
          } label: {
            Text("Cancel")
          }
          Button {
            items.append(newItem)
            saveUserDefaults()
            newItem = ""
          } label: {
            Text("Add")
          }
        }
      }
    }
    .onAppear {
      items = userDefaults.array(forKey: key) as? [String] ?? []
    }
  }

  private func saveUserDefaults() {
    userDefaults.set(items, forKey: key)
    if key == "Unit" {
      units = userDefaults.array(forKey: "Unit") as? [String] ?? []
    } else if key == "Expense" {
      categoriesExpense = userDefaults.array(forKey: "Expense") as? [String] ?? []
    } else if key == "Income" {
      categoriesIncome = userDefaults.array(forKey: "Income") as? [String] ?? []
    }
  }
}
