import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    public var quotaVm: QuotaViewModel = QuotaViewModel()

    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            QuotaInputsView(viewmodel: quotaVm)

            if quotaVm.isLoading {
                ProgressView("Computing quota…")
                    .padding(.top, 16)
            }

            if !(quotaVm.errorMessage.isEmpty) {
                if quotaVm.hasEmptyInputs {
                    NotificationBanner(
                        type: .info,
                        message: "Enter inputs"
                    )
                } else {
                    NotificationBanner(
                        type: .warning,
                        message: quotaVm.errorMessage
                    )
                }
            }

            else if let quota = quotaVm.loadedQuota {
                QuotaTierListView(quota: quota)
                    // .padding(.top, 12)
                    // .padding(.bottom, 16)

                QuotaTierActionsView(quota: quota, clientIdentifier: viewmodel.clientIdentifier)
            }
            else {
                NotificationBanner(
                    type: .info,
                    message: "Enter quote values above"
                )
                .padding(.top, 16)
            }
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: 400)
    }
}
