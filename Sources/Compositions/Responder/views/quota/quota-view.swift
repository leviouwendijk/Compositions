import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    @StateObject public var quotaVm: QuotaViewModel = QuotaViewModel()

    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            VStack {
                HStack {
                    QuotaInputsView(viewmodel: quotaVm)
                    .frame(maxWidth: 300)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                    Spacer()

                    if let quota = quotaVm.loadedQuota {
                        QuotaTierListView(quota: quota)
                    }
                }
            }
            .frame(minHeight: 420)

            Spacer()

            QuotaStatusView(
                viewmodel: quotaVm
            )

            if let quota = quotaVm.loadedQuota {
                QuotaTierActionsView(
                    viewmodel: quotaVm, 
                    quota: quota,
                    clientIdentifier: viewmodel.clientIdentifier
                )
            }
        }
    }
}
