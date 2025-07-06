import SwiftUI
import Structures
import Implementations
import ViewComponents

public struct TaskPriorityView: View {
    @ObservedObject var viewmodel: TaskListViewModel
    @Binding var task: TaskItem

    public var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text("Urgency")
                LevelSelector(
                    level: Binding(
                        get: { task.urgency },
                        set: {
                            viewmodel.updateUrgency(of: task, to: $0)
                            task.urgency = $0
                        }
                    ),
                    maxLevel: 5,
                    activeColor: .red,
                    inactiveColor: .red.opacity(0.2)
                )
            }

            VStack {
                Text("Importance")
                LevelSelector(
                    level: Binding(
                        get: { task.importance },
                        set: {
                            viewmodel.updateImportance(of: task, to: $0)
                            task.importance = $0
                        }
                    ),
                    maxLevel: 5,
                    activeColor: .yellow,
                    inactiveColor: .yellow.opacity(0.2)
                )
            }
        }
    }
}
