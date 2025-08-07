import SwiftUI

struct StudentsView: View {
    @EnvironmentObject var dataStore: AppDataStore
    @State private var newStudentName: String = ""
    @State private var selectedSectionID: UUID?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dataStore.sections) { section in
                        Section(header: Text(section.name)) {
                            let studentsInSection = dataStore.students.filter { $0.sectionID == section.id }
                            if studentsInSection.isEmpty {
                                Text("لا يوجد طلاب في هذه الشعبة بعد").foregroundColor(.gray)
                            } else {
                                ForEach(studentsInSection) { student in
                                    Text(student.name)
                                }
                            }
                        }
                    }
                }

                // نموذج إضافة طالب جديد
                VStack(spacing: 15) {
                    TextField("أدخل اسم الطالب الجديد", text: $newStudentName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if !dataStore.sections.isEmpty {
                        Picker("اختر الشعبة", selection: $selectedSectionID) {
                            ForEach(dataStore.sections) { section in
                                Text(section.name).tag(section.id as UUID?)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Button(action: addStudent) {
                            Text("إضافة طالب")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(newStudentName.isEmpty || selectedSectionID == nil)
                    } else {
                        Text("يرجى إضافة شعبة أولاً").foregroundColor(.red)
                    }

                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(15)
                .padding(.horizontal)

            }
            .navigationTitle("الطلاب")
            .onAppear {
                // تحديد القيمة الافتراضية للـ picker
                if selectedSectionID == nil {
                    selectedSectionID = dataStore.sections.first?.id
                }
            }
        }
    }

    private func addStudent() {
        guard let sectionID = selectedSectionID else { return }
        dataStore.addStudent(name: newStudentName, sectionID: sectionID)
        newStudentName = "" // تفريغ الحقل
    }
}

struct StudentsView_Previews: PreviewProvider {
    static var previews: some View {
        // إنشاء بيانات وهمية للمعاينة
        let previewStore = AppDataStore()
        let section1 = Section(name: "الشعبة أ")
        let section2 = Section(name: "الشعبة ب")
        previewStore.sections = [section1, section2]
        previewStore.students = [
            Student(name: "أحمد", sectionID: section1.id),
            Student(name: "محمد", sectionID: section1.id)
        ]

        return StudentsView()
            .environmentObject(previewStore)
            .environment(\.locale, .init(identifier: "ar"))
    }
}
