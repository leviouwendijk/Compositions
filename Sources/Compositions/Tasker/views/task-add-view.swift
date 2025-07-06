import SwiftUI
import Structures
import Implementations
import ViewComponents
import Extensions

public struct AddTaskView: View {
    @Environment(\.presentationMode) private var presentation
    @ObservedObject public var viewmodel: TaskListViewModel

    @State private var title       = ""
    @State private var description = ""
    @State private var deadline    = Date().addingTimeInterval(3600)
    @State private var urgency     = 3
    @State private var importance  = 3
    @State private var project: TaskProject
    @State private var department  = TaskDepartment.marketing

    public init(viewmodel: TaskListViewModel) {
        self.viewmodel = viewmodel
        let firstProj = viewmodel.projects.first ?? TaskProject(name: "Default Project")
        _project = State(initialValue: firstProj)
    }

    public var body: some View {
        VStack(spacing: 0) {
            // header
            HStack {
                Text("New Task")
                    .font(.title2).bold()
                Spacer()
                Button("Cancel") { presentation.wrappedValue.dismiss() }
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
                    viewmodel.add(newTask)
                    presentation.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            }
            .padding()
            Divider()

            // content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Basics
                    SectionHeader("Basics")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                        TextField("Enter title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Description")
                        TextField("Enter description", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Schedule
                    SectionHeader("Schedule")
                    DatePicker("Deadline", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()

                    // Priority
                    SectionHeader("Priority")
                    HStack(spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Urgency: \(urgency)")
                            Slider(value: Binding(
                                get: { Double(urgency) },
                                set: { urgency = Int($0) }
                            ), in: 1...5, step: 1)
                        }
                        VStack(alignment: .leading) {
                            Text("Importance: \(importance)")
                            Slider(value: Binding(
                                get: { Double(importance) },
                                set: { importance = Int($0) }
                            ), in: 1...5, step: 1)
                        }
                    }

                    // Context
                    SectionHeader("Context")
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Project")
                            Picker("", selection: $project) {
                                ForEach(viewmodel.projects) { proj in
                                    Text(proj.name).tag(proj)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        VStack(alignment: .leading) {
                            Text("Department")
                            Picker("", selection: $department) {
                                ForEach(TaskDepartment.allCases) { dept in
                                    Text(dept.rawValue).tag(dept)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 600, minHeight: 500)
    }

    private func SectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
            .padding(.top, 8)
    }
}
