import Foundation
import SwiftUI
import Implementations

public struct PostcodeLookupView: View {
    @StateObject public var vm = PostcodeLookupViewModel()

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                TextField("Postcode (bv. 1816PN)", text: $vm.postcode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 160)
                    // .textInputAutocapitalization(.characters)
                    .disableAutocorrection(true)

                TextField("Huisnummer", text: $vm.huisnummer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)
                    // .keyboardType(.numbersAndPunctuation)

                Button {
                    Task { await vm.lookup() }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                    } else {
                        Text("Zoek")
                    }
                }
                .disabled(!vm.canSearch)
            }

            if !vm.errorMessage.isEmpty {
                Text(vm.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            GroupBox(label: Text("Gevonden")) {
                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                    GridRow {
                        Text("Straat").fontWeight(.semibold)
                        Text(vm.street.isEmpty ? "—" : vm.street)
                    }
                    GridRow {
                        Text("Woonplaats").fontWeight(.semibold)
                        Text(vm.woonplaats.isEmpty ? "—" : vm.woonplaats)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            GroupBox(label: Text("Ruwe JSON-respons")) {
                ScrollView {
                    Text(vm.rawJSON.isEmpty ? "—" : vm.rawJSON)
                        .font(.system(.footnote, design: .monospaced))
                        .textSelection(.enabled) // allow copy, but not editing
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                }
                .frame(minHeight: 160, maxHeight: 280)
            }

            Spacer()
        }
        .padding()
    }
}
