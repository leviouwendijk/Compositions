import SwiftUI
import Structures
import Implementations
import ViewComponents
import Extensions

public struct TaskRowView: View {
    @ObservedObject public var viewmodel: TaskListViewModel
    @State public var task: TaskItem

    @State private var now = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TaskRowHeaderView(viewmodel: viewmodel, task: $task)
                    Spacer()
                    TaskProjectDeptView(viewmodel: viewmodel, task: $task)
                    .frame(maxWidth: 400)
                }
                TaskDeadlineView(viewmodel: viewmodel, task: $task)
                TaskPriorityView(viewmodel: viewmodel, task: $task)
                TaskTimerView(viewmodel: viewmodel, task: $task, now: now)
            }

            Button {
                viewmodel.delete(task)
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
        .onReceive(timer) { now = $0 }
    }
}
