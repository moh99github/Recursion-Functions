import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SectionsView()
                .tabItem {
                    Label("الشعب", systemImage: "rectangle.3.group")
                }

            StudentsView()
                .tabItem {
                    Label("الطلاب", systemImage: "person.2")
                }

            AttendanceView()
                .tabItem {
                    Label("الغياب", systemImage: "list.bullet.clipboard")
                }

            StatisticsView()
                .tabItem {
                    Label("الإحصائيات", systemImage: "chart.pie")
                }
        }
        // يضمن أن الواجهة تعمل بشكل جيد مع اللغة العربية
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppDataStore())
            .environment(\.locale, .init(identifier: "ar"))
    }
}
