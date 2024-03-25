import SwiftUI
import SwiftData

struct InputView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Data.date, order: .reverse) private var datas: [Data]

  @Binding var modes: [String]
  @Binding var units: [String]
  @Binding var categoriesExpense: [String]
  @Binding var categoriesIncome: [String]

  @State private var categories: [String] = []
  @State private var categoriesFlag: [Bool] = []

  @State private var inputMode: String = ""
  @State private var inputPrice: String = ""
  @State private var inputUnit: String = ""
  @State private var inputCategory: String = ""
  @State private var inputDate: Date = Date()
  @State private var inputNote: String = ""

  var body: some View {
    VStack {
      Picker("Mode", selection: $inputMode) {
        ForEach(modes, id: \.self) { mode in
          Text(mode)
            .tag(mode)
        }
      }
      .onChange(of: inputMode) {
        setCategories()
        selectCategory(index: 0)
      }
      .pickerStyle(.segmented)
      .padding(.all, 6)

      generateBorder()

      if !units.isEmpty {
        Picker("Unit", selection: $inputUnit) {
          ForEach(units, id: \.self) { unit in
            Text(unit)
              .tag(unit)
          }
        }
        .pickerStyle(.segmented)
      } else {
        HStack {
          Text("Add Units in Setting")
            .foregroundStyle(.gray)
            .padding(EdgeInsets(
              top: 2,
              leading: 6,
              bottom: 2,
              trailing: 6
            ))
          Spacer()
        }
      }

      generateBorder()

      HStack {
        Text("Price(\(inputUnit))")
        TextField("Price(\(inputUnit))", text: $inputPrice)
          .keyboardType(.numberPad)
          .multilineTextAlignment(TextAlignment.trailing)
          .padding(.all, 6)
      }
      .padding(EdgeInsets(
        top: 2,
        leading: 6,
        bottom: 2,
        trailing: 6
      ))

      generateBorder()

      HStack {
        Text("Category")
        Spacer()
      }
      .padding(EdgeInsets(
        top: 2,
        leading: 6,
        bottom: 0,
        trailing: 6
      ))

      ZStack(alignment: .topLeading) {
        if !categories.isEmpty {
          var width = CGFloat.zero
          var height = CGFloat.zero
          ForEach(0..<categories.count, id: \.self, content: { index in
            Button(action: {
              selectCategory(index: index)
            }, label: {
              Text(categories[index])
                .padding(.all, 12)
                .background(categoriesFlag[index] ? appColor.selectedColor : appColor.bgColor)
                .foregroundStyle(appColor.letterColor)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .stroke(appColor.borderColor, lineWidth: 3)
                )
                .cornerRadius(10)
            })
            .padding([.horizontal, .vertical], 4)
            .alignmentGuide(.leading, computeValue: { dimension in
              if abs(width - dimension.width) > UIScreen.main.bounds.width {
                width = 0
                height -= dimension.height
              }
              let result = width
              if categories[index] == categories[categories.count - 1] {
                width = 0
              } else {
                width -= dimension.width
              }
              return result
            })
            .alignmentGuide(.top, computeValue: { _ in
              let result = height
              if categories[index] == categories[categories.count - 1] {
                height = 0
              }
              return result
            })
          })
        } else {
          Text("Add Categories in Setting")
            .foregroundStyle(.gray)
            .padding(EdgeInsets(
              top: 2,
              leading: 6,
              bottom: 2,
              trailing: 6
            ))
        }
      }
      .padding(EdgeInsets(
        top: 0,
        leading: 6,
        bottom: 2,
        trailing: 6
      ))

      generateBorder()

      DatePicker(
        selection: $inputDate,
        displayedComponents: [.date],
        label: {Text("Date")}
      )
      .padding(EdgeInsets(
        top: 2,
        leading: 6,
        bottom: 2,
        trailing: 6
      ))

      generateBorder()

      HStack {
        Text("Note")
        TextField("Note", text: $inputNote)
          .multilineTextAlignment(TextAlignment.trailing)
          .padding(.all, 6)
      }
      .padding(EdgeInsets(
        top: 2,
        leading: 6,
        bottom: 2,
        trailing: 6
      ))

      generateBorder()

      Button(action: {
        saveData()
      }, label: {
        Text("Save")
          .padding(.all, 12)
          .background(appColor.selectedColor)
          .foregroundStyle(appColor.letterColor)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(appColor.borderColor, lineWidth: 3)
          )
          .cornerRadius(10)
      })
      .padding(.all, 12)

      Spacer()
    }
    .onAppear {
      if inputMode == "" {
        inputMode = modes[0]
      }
      if inputUnit == "" {
        if !units.isEmpty {
          inputUnit = units[0]
        }
      }
      setCategories()
      selectCategory(index: 0)
    }
    .padding(.all, 12)
    .background(appColor.bgColor)
  }

  private func generateBorder() -> some View {
    return Rectangle()
      .frame(width: UIScreen.main.bounds.width, height: 1)
      .foregroundStyle(appColor.borderColor)
  }

  private func setCategories() {
    if inputMode == modes[0] {
      categories = categoriesExpense
    } else if inputMode == modes[1] {
      categories = categoriesIncome
    } else {
      print("Error: inputMode is empty")
    }

    categoriesFlag = []
    for _ in 0..<categories.count {
      categoriesFlag += [false]
    }
  }

  private func selectCategory(index: Int) {
    if !categories.isEmpty {
      for i in 0..<categoriesFlag.count {
        categoriesFlag[i] = false
      }
      categoriesFlag[index] = true
      inputCategory = categories[index]
    }
  }

  private func saveData() {
    let newData = Data(mode: inputMode, price: inputPrice, unit: inputUnit, category: inputCategory, date: inputDate, note: inputNote)
    modelContext.insert(newData)
    inputPrice = ""
    inputNote = ""
  }

}
