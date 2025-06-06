import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaView: View {
    @ObsersvedObject public var viewmodel: ResponderViewModel
    
    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            QuotaInputsView(viewmodel: viewmodel)

            if viewmodel.quotaVm.isLoading {
                ProgressView("Computing quota…")
                    .padding(.top, 16)
            }

            if !(viewmodel.quotaVm.errorMessage.isEmpty) {
                if viewmodel.quotaVm.hasEmptyInputs {
                    NotificationBanner(
                        type: .info,
                        message: "Enter inputs"
                    )
                } else {
                    NotificationBanner(
                        type: .warning,
                        message: viewmodel.quotaVm.errorMessage
                    )
                }
            }

            else if let quota = viewmodel.quotaVm.loadedQuota {
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
