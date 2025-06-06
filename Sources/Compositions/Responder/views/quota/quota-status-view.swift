import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaStatusView: View {
    @ObservedObject public var viewmodel: QuotaViewModel

    public init(
        viewmodel: QuotaViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            if viewmodel.isLoading {
                ProgressView("Computing quota…")
                    .padding(.top, 16)
            }

            if !(viewmodel.errorMessage.isEmpty) {
                if viewmodel.hasEmptyInputs {
                    NotificationBanner(
                        type: .info,
                        message: "Enter quote value inputs"
                    )
                } else {
                    NotificationBanner(
                        type: .warning,
                        message: viewmodel.errorMessage
                    )
                }
            }
        }
        .frame(minWidth: 300, alignment: .center)
    }
}
