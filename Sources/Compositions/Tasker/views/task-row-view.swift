import SwiftUI
import Structures
import Implementations
import ViewComponents
import Extensions

public struct TaskRowView: View {
    @ObservedObject public var viewmodel: TaskListViewModel
    @State public var task: TaskItem

    @State private var now   = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    public init(
        viewmodel: TaskListViewModel,
        task: TaskItem
    ) {
        self.viewmodel = viewmodel
        self.task = task
    }

    private var isOverdue: Bool {
        return viewmodel.isOverdue(task)
    }

    private var timeOpen: String {
        return "\(viewmodel.timeOpen(for: task))"
    }

    private var timeLeft: String {
        return "\(viewmodel.timeLeft(for: task))"
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .top) {
                Button {
                    viewmodel.toggleCompletion(of: task)
                    task.completion.toggle()
                } label: {
                    Image(systemName: task.completion ? "checkmark.circle.fill" : "circle")
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: 6) {
                    EditableText(controller: EditableTextController(text: task.title))
                        .onChange(of: task.title) { newText in
                            viewmodel.updateTitle(of: task, to: newText)
                            task.title = newText
                        }
                    EditableText(controller: EditableTextController(text: task.description))
                        .onChange(of: task.description) { newText in
                            viewmodel.updateDescription(of: task, to: newText)
                            task.description = newText
                        }
                }
            }

            HStack {
                Text("Deadline:")
                DatePicker(
                    "",
                    selection: Binding(
                        get: { task.deadline },
                        set: { newDate in
                            viewmodel.updateDeadline(of: task, to: newDate)
                            task.deadline = newDate
                        }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
            }

            HStack(spacing: 16) {
                VStack {
                    Text("Urgency")
                    LevelSelector(
                        level: Binding(
                          get: { task.urgency },
                          set: { new in viewmodel.updateUrgency(of: task, to: new); task.urgency = new }
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
                          set: { new in viewmodel.updateImportance(of: task, to: new); task.importance = new }
                        ),
                        maxLevel: 5,
                        activeColor: .yellow,
                        inactiveColor: .yellow.opacity(0.2)
                    )
                }
            }

            HStack(spacing: 16) {
                Picker("Project", selection: Binding(
                    get: { task.project },
                    set: { newProj in
                        viewmodel.updateTaskProject(of: task, to: newProj)
                        task.project = newProj
                    }
                )) {
                    ForEach(viewmodel.projects) { proj in
                        Text(proj.name).tag(proj)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Dept", selection: Binding(
                    get: { task.department },
                    set: { newDept in
                        viewmodel.updateDepartment(of: task, to: newDept)
                        task.department = newDept
                    }
                )) {
                    ForEach(TaskDepartment.allCases) { dept in
                        Text(dept.rawValue).tag(dept)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            HStack {
                Text("Open: \(self.timeOpen)")
                Spacer()
                Text("Left: \(self.timeLeft)")
                    .foregroundColor(self.isOverdue ? .red : .primary)
            }
            .font(.caption2)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.clear)
                // .fill(Color.gray.opacity(0.1))
                // .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
        .onReceive(timer) { _ in now = Date() }
    }
}
