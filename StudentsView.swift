import SwiftUI

struct StudentsView: View {
    @EnvironmentObject var dataStore: AppDataStore
    @State private var newStudentName: String = ""
    @State private var selectedSectionID: UUID?

    var body: some View {
        NavigationView {
            VStack {
                // القائمة الآن تستخدم الواجهة الفرعية الجديدة
                List {
                    ForEach(dataStore.sections) { section in
                        StudentListSection(section: section)
                    }
                }

                AddStudentForm(
                    newStudentName: $newStudentName,
                    selectedSectionID: $selectedSectionID
                )
            }
            .navigationTitle("الطلاب")
            .onAppear {
                if selectedSectionID == nil {
                    selectedSectionID = dataStore.sections.first?.id
                }
            }
        }
    }
}

// --- واجهة فرعية: قسم عرض الطلاب ---
// تم إنشاء هذه الواجهة لحل مشكلة "Extra argument in call"
// عن طريق فصل منطق عرض الطلاب في قسم خاص
struct StudentListSection: View {
    @EnvironmentObject var dataStore: AppDataStore
    let section: Section

    // نقوم بحساب الطلاب هنا بدلاً من داخل جسم الواجهة مباشرة
    private var studentsInSection: [Student] {
        dataStore.students.filter { $0.sectionID == section.id }
    }

    var body: some View {
        Section(header: Text(section.name)) {
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


// --- واجهة فرعية: نموذج إضافة طالب ---
struct AddStudentForm: View {
    @EnvironmentObject var dataStore: AppDataStore
    @Binding var newStudentName: String
    @Binding var selectedSectionID: UUID?

    var body: some View {
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

    private func addStudent() {
        guard let sectionID = selectedSectionID else { return }
        dataStore.addStudent(name: newStudentName, sectionID: sectionID)
        newStudentName = ""
    }
}


struct StudentsView_Previews: PreviewProvider {
    static var previews: some View {
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
