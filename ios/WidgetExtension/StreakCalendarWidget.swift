import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Read from the shared App Group set in WidgetSyncService
    let sharedDefaults = UserDefaults(suiteName: "group.app.formulascholar.widgets")
    
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: Date(), isLoggedIn: true, currentStreak: 5, maxStreak: 12)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> ()) {
        let entry = getEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func getEntry() -> StreakEntry {
        if let dataString = sharedDefaults?.string(forKey: "streak_data"),
           let data = dataString.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let isLoggedIn = json["isLoggedIn"] as? Bool ?? false
            let currentStreak = json["currentStreak"] as? Int ?? 0
            let maxStreak = json["maxStreak"] as? Int ?? 0
            
            return StreakEntry(date: Date(), isLoggedIn: isLoggedIn, currentStreak: currentStreak, maxStreak: maxStreak)
        }
        return StreakEntry(date: Date(), isLoggedIn: false, currentStreak: 0, maxStreak: 0)
    }
}

struct StreakEntry: TimelineEntry {
    let date: Date
    let isLoggedIn: Bool
    let currentStreak: Int
    let maxStreak: Int
}

struct StreakCalendarWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 30/255, green: 30/255, blue: 30/255)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Formula Scholar")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if entry.isLoggedIn {
                    Text("\(entry.currentStreak)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                    
                    Text(entry.currentStreak == 1 ? "Day Streak!" : "Days Streak!")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("Please login")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding()
        }
        // Deep link back to app
        .widgetURL(URL(string: "formulascholar://streak"))
    }
}

struct StreakCalendarWidget: Widget {
    let kind: String = "StreakCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StreakCalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Streak Calendar")
        .description("Track your learning streaks.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
