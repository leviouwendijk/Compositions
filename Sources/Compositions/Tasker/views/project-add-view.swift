import SwiftUI
import Structures
import Implementations
import ViewComponents
import Extensions

public struct AddProjectView: View {
    @Environment(\.presentationMode) private var presentation
    @ObservedObject public var viewmodel: TaskListViewModel

    @State private var name = ""

    public var body: some View {
        VStack(spacing: 16) {
            Text("New Project")
                .font(.headline)

            TextField("Project Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack {
                Button("Cancel") {
                    presentation.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    let proj = TaskProject(name: name)
                    viewmodel.addProject(proj)
                    presentation.wrappedValue.dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(minWidth: 300)
    }
}
