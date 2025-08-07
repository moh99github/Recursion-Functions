import SwiftUI

struct AttendanceView: View {
    @EnvironmentObject var dataStore: AppDataStore
    @State private var selectedSectionID: UUID?
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                // فلتر لاختيار الشعبة والتاريخ
                VStack {
                    if !dataStore.sections.isEmpty {
                        Picker("اختر الشعبة", selection: $selectedSectionID) {
                            ForEach(dataStore.sections) { section in
                                Text(section.name).tag(section.id as UUID?)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        DatePicker("اختر التاريخ", selection: $selectedDate, displayedComponents: .date)
                            .padding()
                            .labelsHidden() // إخفاء عنوان الـ DatePicker

                    } else {
                        Text("يرجى إضافة شعب وطلاب أولاً")
                            .foregroundColor(.red)
                            .padding()
                    }
                }

                // قائمة الطلاب
                List {
                    if let sectionID = selectedSectionID {
                        let studentsInSection = dataStore.students.filter { $0.sectionID == sectionID }
                        if studentsInSection.isEmpty {
                            Text("لا يوجد طلاب في هذه الشعبة").foregroundColor(.gray)
                        } else {
                            ForEach(studentsInSection) { student in
                                StudentAttendanceRow(student: student, selectedDate: $selectedDate)
                            }
                        }
                    } else {
                        Text("الرجاء اختيار شعبة لعرض الطلاب")
                    }
                }
            }
            .navigationTitle("تسجيل الغياب")
            .onAppear {
                // تحديد القيمة الافتراضية للـ picker
                if selectedSectionID == nil {
                    selectedSectionID = dataStore.sections.first?.id
                }
            }
        }
    }
}

// صف لكل طالب في قائمة الغياب
struct StudentAttendanceRow: View {
    @EnvironmentObject var dataStore: AppDataStore
    let student: Student
    @Binding var selectedDate: Date

    // هل الطالب غائب في التاريخ المحدد؟
    private var isAbsent: Bool {
        dataStore.absences.contains {
            $0.studentID == student.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        HStack {
            Text(student.name)
            Spacer()
            Button(action: toggleAbsence) {
                Text(isAbsent ? "غائب" : "حاضر")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isAbsent ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle()) // لإزالة التأثيرات الافتراضية للزر داخل List
        }
    }

    private func toggleAbsence() {
        if isAbsent {
            // إذا كان غائبًا، قم بإزالة سجل الغياب
            dataStore.removeAbsence(studentID: student.id, date: selectedDate)
        } else {
            // إذا كان حاضرًا، قم بإضافة سجل غياب
            dataStore.addAbsence(studentID: student.id, date: selectedDate)
        }
    }
}


struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        let previewStore = AppDataStore()
        let section1 = Section(name: "الشعبة أ")
        let section2 = Section(name: "الشعبة ب")
        let student1 = Student(name: "سالم", sectionID: section1.id)
        let student2 = Student(name: "علي", sectionID: section1.id)

        previewStore.sections = [section1, section2]
        previewStore.students = [student1, student2]
        // جعل الطالب الأول غائبًا كبيانات وهمية
        previewStore.absences.append(Absence(studentID: student1.id, date: Date()))

        return AttendanceView()
            .environmentObject(previewStore)
            .environment(\.locale, .init(identifier: "ar"))
    }
}
