import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Implementations
import Structures

public struct VariablesWAMessageView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    // @ObservedObject public var viewmodel: ResponderViewModel
    public var notifier: NotificationBannerController
    
    public init(
        // viewmodel: ResponderViewModel,
        notifier: NotificationBannerController
    ) {
        // self.viewmodel = viewmodel
        self.notifier = notifier
    }

    public var body: some View {
        VStack {
            // SectionTitle(title: "WhatsApp Message")
            Divider()

            HStack {
                WAMessageDropdown(selected: $viewmodel.selectedWAMessage)

                StandardButton(
                    type: .submit, 
                    title: "WA message", 
                    subtitle: "",
                    action: {
                        if !viewmodel.waMessageContainsRawPlaceholders {
                            withAnimation {
                                notifier.show = false
                            }

                            viewmodel.selectedWAMessageReplaced
                                .clipboard()

                            notifier.message = "WA message copied"
                            notifier.style = .success
                            withAnimation {
                                notifier.show = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation { 
                                    notifier.show = false
                                }
                            }
                        } else {
                            notifier.style = .error
                            notifier.message = "WA message contains raw placeholders"
                            withAnimation {
                                notifier.show = true
                            }
                        }
                    },
                    // image: "message.fill"
                    appearance: ButtonAppearanceConfiguration(
                        image: "message.fill",
                        color: ColorStyleConfiguration(
                            color: .green,
                            foregroundColor: .white
                        )
                    )
                )
                .disabled(viewmodel.selectedWAMessageReplaced.containsRawTemplatePlaceholderSyntaxes())

                Spacer()
            }
            .frame(maxWidth: 350)

            NotificationBanner(
                type: notifier.style,
                message: notifier.message
            )
            .zIndex(2)
            .hide(when: notifier.hide)
        }
    }
}
