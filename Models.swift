import Foundation

// شيكل الشعبة الدراسية
struct Section: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
}

// هيكل الطالب
struct Student: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var sectionID: UUID
}

// هيكل تسجيل الغياب
// سنقوم بتسجيل كل يوم غياب ككائن منفصل
struct Absence: Identifiable, Codable, Hashable {
    var id = UUID()
    var studentID: UUID
    var date: Date
}
