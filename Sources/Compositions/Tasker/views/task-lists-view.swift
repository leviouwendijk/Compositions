import SwiftUI
import Structures
import Implementations

public struct TaskListView: View {
    @ObservedObject public var viewmodel: TaskListViewModel
    @State private var showingAdd = false

    public init(
        viewmodel: TaskListViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sort by:")
                Picker("Sort", selection: $viewmodel.sortOption) {
                    ForEach(TaskSortOption.allCases) { opt in
                        Text(opt.rawValue).tag(opt)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Spacer()

                Button(action: { showingAdd = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .help("Add New Task")
            }
            .padding(.horizontal)

            List {
                ForEach(viewmodel.sortedTaskItems) { task in
                    TaskRowView(viewmodel: viewmodel, task: task)
                }
                .onDelete(perform: viewmodel.remove)
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddTaskView(viewmodel: viewmodel)
            .frame(minWidth: 600, minHeight: 500)
        }
    }
}
