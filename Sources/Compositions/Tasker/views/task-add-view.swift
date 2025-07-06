import SwiftUI
import Structures
import Implementations
import ViewComponents
import Extensions

public struct AddTaskView: View {
    @Environment(\.presentationMode) private var presentation
    @ObservedObject public var vm: TaskListViewModel

    @State private var title       = ""
    @State private var description = ""
    @State private var deadline    = Date().addingTimeInterval(3600)
    @State private var urgency     = 3
    @State private var importance  = 3
    @State private var project: TaskProject
    @State private var department  = TaskDepartment.marketing

    public init(vm: TaskListViewModel) {
        self.vm = vm
        let firstProj = vm.projects.first ?? TaskProject(name: "Default Project")
        _project = State(initialValue: firstProj)
    }

    public var body: some View {
        NavigationView {
            Form {
                Section("Basics") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }

                Section("Schedule") {
                    DatePicker("Deadline", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Priority") {
                    Stepper("Urgency: \(urgency)", value: $urgency, in: 1...5)
                    Stepper("Importance: \(importance)", value: $importance, in: 1...5)
                }

                Section("Context") {
                    Picker("Project", selection: $project) {
                        ForEach(vm.projects) { proj in
                            Text(proj.name).tag(proj)
                        }
                    }
                    Picker("Department", selection: $department) {
                        ForEach(TaskDepartment.allCases) { dept in
                            Text(dept.rawValue).tag(dept)
                        }
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newTask = TaskItem(
                            title:       title,
                            description: description,
                            deadline:    deadline,
                            urgency:     urgency,
                            importance:  importance,
                            project:     project,
                            department:  department
                        )
                        vm.add(newTask)
                        presentation.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
