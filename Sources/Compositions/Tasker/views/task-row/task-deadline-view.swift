import SwiftUI
import Structures
import Implementations

public struct TaskDeadlineView: View {
    @ObservedObject var viewmodel: TaskListViewModel
    @Binding var task: TaskItem

    public var body: some View {
        HStack {
            Text("Deadline:")
            DatePicker(
                "",
                selection: Binding(
                    get: { task.deadline },
                    set: {
                        viewmodel.updateDeadline(of: task, to: $0)
                        task.deadline = $0
                    }
                ),
                displayedComponents: [.date, .hourAndMinute]
            )
            .labelsHidden()
        }
    }
}
