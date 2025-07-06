import SwiftUI
import Structures
import Implementations
import ViewComponents

public struct TaskRowHeaderView: View {
    @ObservedObject var viewmodel: TaskListViewModel
    @Binding var task: TaskItem

    public var body: some View {
        HStack(alignment: .top) {
            Button {
                viewmodel.toggleCompletion(of: task)
                task.completion.toggle()
            } label: {
                Image(systemName: task.completion ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading, spacing: 4) {
                EditableText(controller: EditableTextController(text: task.title))
                .onChange(of: task.title) {
                    viewmodel.updateTitle(of: task, to: $0)
                    task.title = $0
                }
                EditableText(controller: EditableTextController(text: task.description))
                .onChange(of: task.description) {
                    viewmodel.updateDescription(of: task, to: $0)
                    task.description = $0
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}
