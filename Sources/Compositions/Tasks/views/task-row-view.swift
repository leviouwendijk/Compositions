import SwiftUI
import Structures
import Implementations
import ViewComponents
import Extensions

public struct TaskRowView: View {
    @ObservedObject public var vm: TaskListViewModel
    @State public var task: TaskItem

    @State private var now   = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var isOverdue: Bool {
        return vm.isOverdue(task)
    }

    private var timeOpen: String {
        return "\(vm.timeOpen(for: task))"
    }

    private var timeLeft: String {
        return "\(vm.timeLeft(for: task))"
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .top) {
                Button {
                    vm.toggleCompletion(of: task)
                    task.completion.toggle()
                } label: {
                    Image(systemName: task.completion ? "checkmark.circle.fill" : "circle")
                }
                .buttonStyle(PlainButtonStyle())

                VStack(alignment: .leading, spacing: 6) {
                    EditableText(controller: EditableTextController(text: task.title))
                        .onChange(of: task.title) { newText in
                            vm.updateTitle(of: task, to: newText)
                            task.title = newText
                        }
                    EditableText(controller: EditableTextController(text: task.description))
                        .onChange(of: task.description) { newText in
                            vm.updateDescription(of: task, to: newText)
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
                            vm.updateDeadline(of: task, to: newDate)
                            task.deadline = newDate
                        }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
            }

            HStack(spacing: 16) {
                Stepper("Urgency: \(task.urgency)", value: Binding(
                    get: { task.urgency },
                    set: { newLevel in
                        vm.updateUrgency(of: task, to: newLevel)
                        task.urgency = newLevel
                    }
                ), in: 1...5)

                Stepper("Importance: \(task.importance)", value: Binding(
                    get: { task.importance },
                    set: { newLevel in
                        vm.updateImportance(of: task, to: newLevel)
                        task.importance = newLevel
                    }
                ), in: 1...5)
            }

            HStack(spacing: 16) {
                Picker("Project", selection: Binding(
                    get: { task.project },
                    set: { newProj in
                        vm.updateTaskProject(of: task, to: newProj)
                        task.project = newProj
                    }
                )) {
                    ForEach(vm.projects) { proj in
                        Text(proj.name).tag(proj)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Dept", selection: Binding(
                    get: { task.department },
                    set: { newDept in
                        vm.updateDepartment(of: task, to: newDept)
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
                Text("Open: \(self.timeLeft)")
                    .foregroundColor(self.isOverdue ? .red : .primary)
            }
            .font(.caption2)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3))
        )
        .onReceive(timer) { _ in now = Date() }
    }
}
