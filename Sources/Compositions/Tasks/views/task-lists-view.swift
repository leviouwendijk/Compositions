import SwiftUI
import Structures
import Implementations

public struct TaskListView: View {
    @ObservedObject var vm: TaskListViewModel

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sort by:")
                Picker("Sort", selection: $vm.sortOption) {
                    ForEach(TaskSortOption.allCases) { opt in
                        Text(opt.rawValue).tag(opt)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            List {
                ForEach(vm.sortedTaskItems) { task in
                    TaskRowView(vm: vm, task: task)
                }
                .onDelete(perform: vm.remove)
            }
        }
    }
}
