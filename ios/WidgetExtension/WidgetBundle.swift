import WidgetKit
import SwiftUI

@main
struct FormulaScholarWidgetsBundle: WidgetBundle {
    var body: some Widget {
        StreakCalendarWidget()
        StudyPlannerWidget()
    }
}

// Since @main is here, we need the actual StudyPlannerWidget struct
struct StudyPlannerWidget: Widget {
    let kind: String = "StudyPlannerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PlannerProvider()) { entry in
            StudyPlannerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Study Planner")
        .description("Keep track of your upcoming study sessions.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
