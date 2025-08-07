import SwiftUI

struct SectionsView: View {
    @EnvironmentObject var dataStore: AppDataStore
    @State private var newSectionName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dataStore.sections) { section in
                        Text(section.name)
                    }
                }

                HStack {
                    TextField("أدخل اسم الشعبة الجديدة", text: $newSectionName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: addSection) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    .padding()
                    .disabled(newSectionName.isEmpty)
                }
            }
            .navigationTitle("الشعب الدراسية")
        }
    }

    private func addSection() {
        dataStore.addSection(name: newSectionName)
        newSectionName = "" // تفريغ الحقل بعد الإضافة
    }
}

struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        SectionsView()
            .environmentObject(AppDataStore())
            .environment(\.locale, .init(identifier: "ar"))
    }
}
