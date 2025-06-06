import SwiftUI
import plate
import ViewComponents
import Implementations

public struct CustomMessagePaneView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    
    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack(alignment: .leading) {

            TextField("Subject", text: $viewmodel.subject)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if (viewmodel.anyInvalidConditionsCheck && viewmodel.emptySubjectWarning) {
                NotificationBanner(
                    type: .info,
                    message: "Empty subject"
                )
            }

            Text("Template HTML").bold()

            CodeEditorContainer(text: $viewmodel.fetchedHtml)

            if (viewmodel.anyInvalidConditionsCheck && viewmodel.finalHtmlContainsRawVariables) {
                NotificationBanner(
                    type: .warning,
                    message: "Raw html variables still in your message"
                )
            }

            HStack {
                StandardButton(
                    type: .clear, 
                    title: "Clear HTML", 
                    subtitle: "clears fetched html"
                ) {
                    viewmodel.fetchedHtml = ""
                }

                Spacer()

                if viewmodel.apiPathVm.selectedRoute == .custom {
                    StandardToggle(
                        style: .switch,
                        isOn: $viewmodel.includeQuoteInCustomMessage,
                        title: "Include quote",
                        subtitle: nil,
                        width: 150
                    )
                }
            }
            .padding()
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}
