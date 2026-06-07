import WidgetKit
import SwiftUI

struct StreakProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: Date(), isLoggedIn: true, currentStreak: 5, maxStreak: 12)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> ()) {
        let entry = getStreakData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getStreakData()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func getStreakData() -> StreakEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.app.formulascholar.widgets")
        let streakDataString = sharedDefaults?.string(forKey: "streak_data")
        
        if let dataString = streakDataString, let data = dataString.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let isLoggedIn = json["isLoggedIn"] as? Bool ?? false
                    let currentStreak = json["currentStreak"] as? Int ?? 0
                    let maxStreak = json["maxStreak"] as? Int ?? 0
                    return StreakEntry(date: Date(), isLoggedIn: isLoggedIn, currentStreak: currentStreak, maxStreak: maxStreak)
                }
            } catch {
                print("Error parsing streak data")
            }
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
    var entry: StreakProvider.Entry

    var body: some View {
        ZStack {
            Color(red: 30/255, green: 30/255, blue: 30/255).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Formula Scholar")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
                
                if entry.isLoggedIn {
                    HStack {
                        Text("🔥")
                            .font(.system(size: 32))
                        
                        VStack(alignment: .leading) {
                            Text("\(entry.currentStreak) Days")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Best: \(entry.maxStreak)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("Log in to see your streak!")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .widgetURL(URL(string: "homeWidget://streak"))
    }
}

struct StreakCalendarWidget: Widget {
    let kind: String = "StreakCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            StreakCalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Streak Tracker")
        .description("Keep track of your learning streak.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
