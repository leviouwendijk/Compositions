import Foundation
import SwiftUI
import Combine
import plate
import ViewComponents
import Economics
import Interfaces
import Implementations
import Structures

public struct MailerStandardOutput: View {
    @EnvironmentObject public var vm: ResponderViewModel

    public init() {}

    public var body: some View {
        VStack {
            VStack {
                SectionTitle(title: "mailer command", width: 150)

                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(vm.sharedMailerCommandCopy, forType: .string)
                }) {
                    Text(vm.sharedMailerCommandCopy)
                    .bold()
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: 800, alignment: .center)
            } 

            VStack {
                SectionTitle(title: "stdout log", width: 150)

                ScrollView {
                    Text(vm.mailerOutput)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(4)
                }
                .background(Color.black.opacity(0.05))
                .cornerRadius(6)

                .frame(maxWidth: 800, alignment: .center)

                HStack {
                    StandardButton(
                        type: .copy, 
                        title: "Copy stdout"
                    ) {
                        copyToClipboard(vm.mailerOutput)
                    }
                }
                // .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
            }
        }
    }
}
