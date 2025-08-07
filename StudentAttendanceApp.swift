import SwiftUI

@main
struct StudentAttendanceApp: App {
    // إنشاء مدير البيانات كـ @StateObject لضمان بقائه طوال دورة حياة التطبيق
    @StateObject private var dataStore = AppDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // حقن مدير البيانات في بيئة الواجهة الرئيسية
                // لتتمكن جميع الشاشات الفرعية من الوصول إليه
                .environmentObject(dataStore)
        }
    }
}
