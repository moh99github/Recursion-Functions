import SwiftUI
import Combine

// هيكل وسيط لتجميع كل بيانات التطبيق لسهولة حفظها في ملف واحد
struct ApplicationData: Codable {
    var sections: [Section]
    var students: [Student]
    var absences: [Absence]
}

class AppDataStore: ObservableObject {
    @Published var sections: [Section] = [] {
        didSet { save() }
    }
    @Published var students: [Student] = [] {
        didSet { save() }
    }
    @Published var absences: [Absence] = [] {
        didSet { save() }
    }

    init() {
        // تحميل البيانات عند بدء تشغيل التطبيق
        load()
    }

    // --- دوال إدارة البيانات ---
    func addSection(name: String) {
        let newSection = Section(name: name)
        sections.append(newSection)
    }

    func addStudent(name: String, sectionID: UUID) {
        let newStudent = Student(name: name, sectionID: sectionID)
        students.append(newStudent)
    }

    func addAbsence(studentID: UUID, date: Date) {
        let hasAbsence = absences.contains { $0.studentID == studentID && Calendar.current.isDate($0.date, inSameDayAs: date) }
        if !hasAbsence {
            let newAbsence = Absence(studentID: studentID, date: date)
            absences.append(newAbsence)
        }
    }

    func removeAbsence(studentID: UUID, date: Date) {
        absences.removeAll { $0.studentID == studentID && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // --- دوال الحفظ والتحميل ---

    // الحصول على مسار ملف الحفظ في مجلد المستندات
    private static func getFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("student_attendance.data")
    }

    // حفظ البيانات
    private func save() {
        do {
            let fileURL = try Self.getFileURL()
            let data = ApplicationData(sections: sections, students: students, absences: absences)
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: fileURL)
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }

    // تحميل البيانات
    private func load() {
        do {
            let fileURL = try Self.getFileURL()
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(ApplicationData.self, from: data)
            self.sections = decodedData.sections
            self.students = decodedData.students
            self.absences = decodedData.absences
        } catch {
            // إذا فشل التحميل (مثلاً، في المرة الأولى لتشغيل التطبيق)، لا تفعل شيئًا
            print("Failed to load data, starting fresh: \(error.localizedDescription)")
        }
    }
}
