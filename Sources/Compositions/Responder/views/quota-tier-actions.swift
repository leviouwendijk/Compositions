import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Economics
import Implementations

struct QuotaTierActionsView: View {
    @State private var selectedTier: QuotaTierType = .combined

    @StateObject private var notifier: NotificationBannerController = NotificationBannerController(
        contents: [
            NotificationBannerControllerContents(title: "copied", style: .success, message: "copied"),
        ],
        addingDefaultContents: true
    )

    let quota: CustomQuota
    let clientIdentifier: String

    init(
        quota: CustomQuota,
        clientIdentifier: String
    ) {
        self.quota = quota
        self.clientIdentifier = clientIdentifier
    }

    var body: some View {
        HStack {
            VStack {
                HStack(spacing: 4) {
                    ForEach(QuotaTierType.allCases) { tier in
                        Text(tier.rawValue)
                        .font(.caption2)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(
                            selectedTier == tier
                                ? Color.accentColor.opacity(0.2)
                                : Color.secondary.opacity(0.1)
                        )
                        .cornerRadius(4)
                        .onTapGesture {
                            withAnimation {
                                selectedTier = tier
                            }
                        }
                    }
                }

                HStack {
                    BannerlessNotifyingButton(
                        type: .copy,
                        title: "short",
                        action: {
                            do {
                                let table = try quota.shortInputs(for: selectedTier, clientIdentifier: clientIdentifier) 
                                copyToClipboard(table)
                                notifier.setAndNotify(to: "copied")
                            } catch {
                                notifier.message = error.localizedDescription
                            }
                        },
                        notifier: notifier,
                    )

                    BannerlessNotifyingButton(
                        type: .copy,
                        title: "full",
                        action: {
                            do {
                                let table = try quota.quotaSummary(clientIdentifier: clientIdentifier)
                                copyToClipboard(table)
                                notifier.setAndNotify(to: "copied")
                            } catch {
                                notifier.message = error.localizedDescription
                            }
                        },
                        notifier: notifier
                    )

                    BannerlessNotifyingButton(
                        type: .execute,
                        title: "pdf",
                        action: {
                            do {
                                withAnimation {
                                    notifier.show = false
                                }

                                try renderTier(quota: quota, for: selectedTier)

                                notifier.message = "quota pdf rendered"
                                notifier.style = .success
                                notifier.notify()
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
                    ControlledNotificationBanner(controller: notifier)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
