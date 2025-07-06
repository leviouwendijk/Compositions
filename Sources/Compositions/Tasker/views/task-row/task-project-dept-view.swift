import SwiftUI
import Structures
import Implementations

public struct TaskProjectDeptView: View {
    @ObservedObject var viewmodel: TaskListViewModel
    @Binding var task: TaskItem
    @State private var showingNewProject = false

    public var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text("Project")
                HStack {
                    Picker("", selection: Binding(
                        get: { task.project },
                        set: {
                            viewmodel.updateTaskProject(of: task, to: $0)
                            task.project = $0
                        }
                    )) {
                        ForEach(viewmodel.projects) { proj in
                            Text(proj.name).tag(proj)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Button {
                        showingNewProject = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .help("New Project")
                }
            }

            VStack(alignment: .leading) {
                Text("Dept")
                Picker("", selection: Binding(
                    get: { task.department },
                    set: {
                        viewmodel.updateDepartment(of: task, to: $0)
                        task.department = $0
                    }
                )) {
                    ForEach(TaskDepartment.allCases) { dept in
                        Text(dept.rawValue).tag(dept)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .sheet(isPresented: $showingNewProject) {
            AddProjectView(viewmodel: viewmodel)
        }
    }
}
