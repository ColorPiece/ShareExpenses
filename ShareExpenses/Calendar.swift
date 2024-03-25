import SwiftUI
import SwiftData

struct CalendarView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Data.date, order: .reverse) private var datas: [Data]

  @Binding var modes: [String]
  @Binding var units: [String]

  @State private var modesList: [String] = [""]
  @State private var unitsList: [String] = [""]
  @State private var filterMode: String = ""
  @State private var filterUnit: String = ""

  var body: some View {
    VStack {
      Picker("Mode", selection: $filterMode) {
        ForEach(modesList, id: \.self) { mode in
          Text(mode)
            .tag(mode)
        }
      }
      .pickerStyle(.segmented)
      .padding(.horizontal, 12)
      .onAppear {
        modesList = ["All"] + modes
        if filterMode == "" {
          filterMode = modesList[0]
        }
      }
      if !unitsList.isEmpty {
        Picker("Unit", selection: $filterUnit) {
          ForEach(unitsList, id: \.self) { unit in
            Text(unit)
              .tag(unit)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 12)
        .onAppear {
          unitsList = ["All"] + units
          if filterUnit == "" {
            filterUnit = unitsList[0]
          }
        }
      }

      List {
        ForEach(filterDisplay(originalDatas: datas), id: \.self) { data in
          let formattedDate = dateFormatString(date: data.date)
          VStack {
            HStack {
              Text(formattedDate).font(.footnote)
                .foregroundStyle(appColor.smallLetterColor)
                .padding(.bottom, 2)
              Spacer()
            }
            HStack {
              if data.note == "" {
                Text("\(data.category)")
              } else {
                Text("\(data.category) (\(data.note))")
              }
              Spacer()
              if data.mode == "Income" {
                Text("+\(data.price)\(data.unit)")
                  .foregroundStyle(appColor.plusColor)
              } else if data.mode == "Expense"  {
                Text("-\(data.price)\(data.unit)")
                  .foregroundStyle(appColor.minusColor)
              } else {
                Text("\(data.price)\(data.unit)")
              }
            }
          }
        }
        .onDelete(perform: { indexSet in
          for index in indexSet {
            modelContext.delete(datas[index])
          }
        })
      }
      .listStyle(PlainListStyle())
      .scrollContentBackground(.hidden)
      .background(appColor.bgColor)
    }

  }

  private func filterDisplay(originalDatas: [Data]) -> [Data] {
    var newDatas: [Data]
    if filterMode == "All" && filterUnit == "All" {
      newDatas = originalDatas
    } else if filterMode == "All" {
      newDatas = originalDatas.filter({ $0.unit == filterUnit })
    } else if filterUnit == "All" {
      newDatas = originalDatas.filter({ $0.mode == filterMode })
    } else {
      newDatas = originalDatas.filter({ $0.mode == filterMode && $0.unit == filterUnit })
    }
    return newDatas
  }

  private func dateFormatString(date: Date) -> String {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .none
    df.locale = Locale(identifier: "en_US")
//    df.dateFormat = "dd/MM"
    return df.string(from: date)
  }

}
