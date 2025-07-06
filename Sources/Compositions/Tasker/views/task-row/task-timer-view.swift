import SwiftUI
import Structures
import Implementations
import Extensions

public struct TaskTimerView: View {
    @ObservedObject var viewmodel: TaskListViewModel
    @Binding var task: TaskItem
    let now: Date

    public var body: some View {
        HStack {
            Text("Open: \(viewmodel.timeOpen(for: task))")
            Spacer()
            Text("Left: \(viewmodel.timeLeft(for: task))")
                .foregroundColor(viewmodel.isOverdue(task) ? .red : .primary)
        }
        .font(.caption2)
    }
}
