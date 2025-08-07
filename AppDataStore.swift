import SwiftUI
import Combine

// مدير بيانات التطبيق ليكون مصدر الحقيقة الوحيد
class AppDataStore: ObservableObject {
    @Published var sections: [Section] = []
    @Published var students: [Student] = []
    @Published var absences: [Absence] = []

    // يمكن إضافة دوال هنا لإضافة وحذف وتعديل البيانات
    // على سبيل المثال:
    func addSection(name: String) {
        let newSection = Section(name: name)
        sections.append(newSection)
    }

    func addStudent(name: String, sectionID: UUID) {
        let newStudent = Student(name: name, sectionID: sectionID)
        students.append(newStudent)
    }

    func addAbsence(studentID: UUID, date: Date) {
        // التحقق من عدم تسجيل غياب لنفس الطالب في نفس اليوم مسبقًا
        let hasAbsence = absences.contains { $0.studentID == studentID && Calendar.current.isDate($0.date, inSameDayAs: date) }
        if !hasAbsence {
            let newAbsence = Absence(studentID: studentID, date: date)
            absences.append(newAbsence)
        }
    }

    func removeAbsence(studentID: UUID, date: Date) {
        absences.removeAll { $0.studentID == studentID && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
