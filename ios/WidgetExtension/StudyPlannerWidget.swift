import WidgetKit
import SwiftUI

struct PlannerProvider: TimelineProvider {
    let sharedDefaults = UserDefaults(suiteName: "group.app.formulascholar.widgets")
    
    func placeholder(in context: Context) -> PlannerEntry {
        PlannerEntry(date: Date(), isLoggedIn: true, taskTitle: "Calculus Review", taskTime: "Tomorrow, 10:00 AM")
    }

    func getSnapshot(in context: Context, completion: @escaping (PlannerEntry) -> ()) {
        let entry = getEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func getEntry() -> PlannerEntry {
        if let dataString = sharedDefaults?.string(forKey: "planner_data"),
           let data = dataString.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let isLoggedIn = json["isLoggedIn"] as? Bool ?? false
            
            if let tasks = json["tasks"] as? [[String: Any]], let firstTask = tasks.first {
                let title = firstTask["title"] as? String ?? "Free Day!"
                let time = firstTask["time"] as? String ?? "No upcoming tasks"
                return PlannerEntry(date: Date(), isLoggedIn: isLoggedIn, taskTitle: title, taskTime: time)
            }
            
            return PlannerEntry(date: Date(), isLoggedIn: isLoggedIn, taskTitle: "Free Day!", taskTime: "No upcoming tasks")
        }
        return PlannerEntry(date: Date(), isLoggedIn: false, taskTitle: "", taskTime: "")
    }
}

struct PlannerEntry: TimelineEntry {
    let date: Date
    let isLoggedIn: Bool
    let taskTitle: String
    let taskTime: String
}

struct StudyPlannerWidgetEntryView : View {
    var entry: PlannerProvider.Entry

    var body: some View {
        ZStack {
            Color(red: 30/255, green: 30/255, blue: 30/255)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Study Planner")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if entry.isLoggedIn {
                    Text(entry.taskTitle)
                        .font(.headline)
                        .foregroundColor(Color(red: 100/255, green: 181/255, blue: 246/255))
                    
                    Text(entry.taskTime)
                        .font(.caption2)
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
        .widgetURL(URL(string: "formulascholar://study-planner"))
    }
}

// Note: To use both widgets in one extension, we'll create a WidgetBundle.
// @main
// struct StudyPlannerWidget: Widget { ... }
