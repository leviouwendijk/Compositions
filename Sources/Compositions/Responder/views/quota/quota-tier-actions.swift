import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Economics
import Implementations

public struct QuotaTierActionsView: View {
    @StateObject public var notifier: NotificationBannerController = NotificationBannerController(
        contents: [
            NotificationBannerControllerContents(title: "copied", style: .success, message: "copied"),
        ],
        addingDefaultContents: true
    )

    @ObservedObject public var viewmodel: QuotaViewModel
    public let clientIdentifier: String
    
    public init(
        viewmodel: QuotaViewModel,
        clientIdentifier: String
    ) {
        self.viewmodel = viewmodel
        self.clientIdentifier = clientIdentifier
    }

    public var body: some View {
        HStack {
            if let quota = viewmodel.loadedQuota {
                VStack {
                    // HStack(spacing: 4) {
                    //     ForEach(QuotaTierType.allCases) { tier in
                    //         SelectableRow(
                    //             title: tier.rawValue,
                    //             isSelected: (viewmodel.selectedTier == tier),
                    //             action: { viewmodel.selectedTier = tier }
                    //         )
                    //         .frame(maxWidth: 100)
                    //     }
                    // }

                    if clientIdentifier.isEmpty {
                        NotificationBanner(
                            type: .info,
                            message: "Select a contact for copyable string"
                        )
                    }

                    HStack {
                        BannerlessNotifyingButton(
                            type: .copy,
                            title: "short",
                            action: {
                                do {
                                    // let table = try quota.shortInputs(for: viewmodel.selectedTier, clientIdentifier: clientIdentifier) 
                                    let string = try viewmodel.copyable(length: .short, clientIdentifier: clientIdentifier) 
                                    copyToClipboard(string)
                                    notifier.setAndNotify(to: "copied")
                                } catch {
                                    notifier.message = error.localizedDescription
                                }
                            },
                            notifier: notifier,
                        )
                        .disabled(viewmodel.selectedTierIsNil)

                        BannerlessNotifyingButton(
                            type: .copy,
                            title: "full",
                            action: {
                                do {
                                    let string = try viewmodel.copyable(length: .long, clientIdentifier: clientIdentifier) 
                                    copyToClipboard(string)
                                    notifier.setAndNotify(to: "copied")
                                } catch {
                                    notifier.message = error.localizedDescription
                                }
                            },
                            notifier: notifier
                        )
                        .disabled(viewmodel.selectedTierIsNil)

                        BannerlessNotifyingButton(
                            type: .execute,
                            title: "pdf",
                            action: {
                                do {
                                    withAnimation {
                                        notifier.show = false
                                    }

                                    if let tier = viewmodel.selectedTier {
                                        try renderTier(quota: quota, for: tier)

                                        notifier.message = "quota pdf rendered"
                                        notifier.style = .success
                                        notifier.notify()
                                    } else {
                                        notifier.message = "no tier selected"
                                        notifier.style = .warning
                                        notifier.notify()
                                    }
                                } catch {
                                    withAnimation {
                                        notifier.show = false
                                    }

                                    notifier.message = "render failed: \(error)"
                                    notifier.style = .error
                                    notifier.notify()
                                }
                            },
                            notifier: notifier
                        )
                        .disabled(viewmodel.selectedTierIsNil)
                    }
                    ControlledNotificationBanner(controller: notifier)
                }
            // } else {
            //     NotificationBanner(
            //         type: .info,
            //         message: "No quota available"
            //     )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
