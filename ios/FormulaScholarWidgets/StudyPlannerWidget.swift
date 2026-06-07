import WidgetKit
import SwiftUI

struct PlannerTask: Hashable {
    let title: String
    let timestamp: Int
}

struct PlannerProvider: TimelineProvider {
    func placeholder(in context: Context) -> PlannerEntry {
        PlannerEntry(date: Date(), isLoggedIn: true, tasks: [
            PlannerTask(title: "Math Chapter 1", timestamp: Int(Date().timeIntervalSince1970 * 1000)),
            PlannerTask(title: "Physics Revision", timestamp: Int(Date().addingTimeInterval(3600).timeIntervalSince1970 * 1000))
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (PlannerEntry) -> ()) {
        let entry = getPlannerData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getPlannerData()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func getPlannerData() -> PlannerEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.app.formulascholar.widgets")
        let plannerDataString = sharedDefaults?.string(forKey: "planner_data")
        
        var tasks: [PlannerTask] = []
        var isLoggedIn = false
        
        if let dataString = plannerDataString, let data = dataString.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    isLoggedIn = json["isLoggedIn"] as? Bool ?? false
                    if let tasksArray = json["tasks"] as? [[String: Any]] {
                        for taskDict in tasksArray {
                            let title = taskDict["title"] as? String ?? "Task"
                            let timestamp = taskDict["timestamp"] as? Int ?? 0
                            tasks.append(PlannerTask(title: title, timestamp: timestamp))
                        }
                    }
                }
            } catch {
                print("Error parsing planner data")
            }
        }
        return PlannerEntry(date: Date(), isLoggedIn: isLoggedIn, tasks: tasks)
    }
}

struct PlannerEntry: TimelineEntry {
    let date: Date
    let isLoggedIn: Bool
    let tasks: [PlannerTask]
}

struct StudyPlannerWidgetEntryView : View {
    var entry: PlannerProvider.Entry

    func formatDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter.string(from: date)
    }

    var body: some View {
        ZStack {
            Color(red: 30/255, green: 30/255, blue: 30/255).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Upcoming Sessions")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
                
                if entry.isLoggedIn {
                    if entry.tasks.isEmpty {
                        Text("No upcoming tasks! 🎉")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(entry.tasks.prefix(3), id: \.self) { task in
                                Text("• \(task.title) (\(formatDate(task.timestamp)))")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                        }
                    }
                } else {
                    Text("Log in to view your planner.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
        }
        .widgetURL(URL(string: "homeWidget://planner"))
    }
}

struct StudyPlannerWidget: Widget {
    let kind: String = "StudyPlannerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PlannerProvider()) { entry in
            StudyPlannerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Study Planner")
        .description("View your upcoming study sessions.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
