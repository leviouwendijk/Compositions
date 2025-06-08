import SwiftUI
import Combine
import plate
import ViewComponents
import Economics
import Implementations

public struct IncomeAllocatorView: View {
    @StateObject public var viewmodel: IncomeAllocatorViewModel

    public init(viewmodel: IncomeAllocatorViewModel? = nil) {
        _viewmodel = StateObject(wrappedValue: viewmodel ?? IncomeAllocatorViewModel())
    }

    public var body: some View {
        HStack(spacing: 12) {
            IncomeAllocatorAccountsView(
                viewmodel: viewmodel.allocatorVm
            )
            .frame(maxWidth: 600)

            Divider()

            CompounderView(
                viewmodel: viewmodel.compounderVm
            )
            .frame(maxWidth: 300)
        }
        .navigationTitle("Income Allocator")
    }
}
