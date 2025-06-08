import SwiftUI
import Combine
import plate
import ViewComponents
import Economics
import Implementations

public struct IncomeAllocatorView: View {
    @StateObject public var viewmodel: IncomeAllocatorViewModel

    public init(viewmodel: IncomeAllocatorViewModel? = nil) {
        let vm = IncomeAllocatorViewModel()
        _viewmodel = StateObject(wrappedValue: viewmodel ?? vm)
    }

    public var body: some View {
        VStack {
            if let alloc = viewmodel.allocatorVm {
                HStack(spacing: 12) {
                    IncomeAllocatorAccountsView(
                        viewmodel: alloc
                    )
                    .frame(maxWidth: 600)

                    Divider()

                    CompounderView(
                        viewmodel: viewmodel.compounderVm
                    )
                    .frame(maxWidth: 300)
                }
            }

            if !viewmodel.errorMessage.isEmpty {
                NotificationBanner(
                    type: .error,
                    message: viewmodel.errorMessage
                )
            }
        }
        // .navigationTitle("Income Allocator")
    }
}
