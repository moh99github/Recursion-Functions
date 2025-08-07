import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataStore: AppDataStore

    var body: some View {
        NavigationView {
            List {
                // القسم الأول: إحصائيات الشعب
                Section(header: Text("إحصائيات الشعب").font(.headline)) {
                    if dataStore.sections.isEmpty {
                        Text("لا توجد شعب لعرض الإحصائيات")
                    } else {
                        ForEach(dataStore.sections) { section in
                            HStack {
                                Text(section.name)
                                Spacer()
                                // حساب عدد الطلاب في كل شعبة
                                let studentCount = dataStore.students.filter { $0.sectionID == section.id }.count
                                Text("\(studentCount) طالب")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // القسم الثاني: إحصائيات غياب الطلاب
                Section(header: Text("إحصائيات غياب الطلاب").font(.headline)) {
                    if dataStore.students.isEmpty {
                        Text("لا يوجد طلاب لعرض الإحصائيات")
                    } else {
                        ForEach(dataStore.students) { student in
                            HStack {
                                Text(student.name)
                                Spacer()
                                // حساب عدد الغيابات لكل طالب
                                let absenceCount = dataStore.absences.filter { $0.studentID == student.id }.count
                                Text("غائب \(absenceCount) يوم")
                                    .foregroundColor(absenceCount > 0 ? .red : .secondary)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("الإحصائيات")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        // إنشاء بيانات وهمية للمعاينة
        let previewStore = AppDataStore()
        let section1 = Section(name: "علوم الحاسب")
        let section2 = Section(name: "الهندسة")
        let student1 = Student(name: "خالد", sectionID: section1.id)
        let student2 = Student(name: "سارة", sectionID: section1.id)
        let student3 = Student(name: "علي", sectionID: section2.id)

        previewStore.sections = [section1, section2]
        previewStore.students = [student1, student2, student3]

        // إضافة غيابات وهمية
        previewStore.absences = [
            Absence(studentID: student1.id, date: Date()),
            Absence(studentID: student1.id, date: Date().addingTimeInterval(-86400)), // غياب يومين لخالد
            Absence(studentID: student3.id, date: Date()) // غياب يوم واحد لعلي
        ]

        return StatisticsView()
            .environmentObject(previewStore)
            .environment(\.locale, .init(identifier: "ar"))
    }
}
