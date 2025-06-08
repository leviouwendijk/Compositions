import SwiftUI
import Combine
import plate
import ViewComponents
import Economics
import Implementations

// public struct IncomeAllocatorLineView: View {
//     public let text: String
//     public let value: String
// }


public struct IncomeAllocatorAccountsView: View {
    @StateObject public var viewmodel: IncomeAllocatorAccountsViewModel

    public init(viewmodel: IncomeAllocatorAccountsViewModel? = nil) {
        _viewmodel = StateObject(wrappedValue: viewmodel ?? IncomeAllocatorAccountsViewModel())
    }

    public var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                Text("Allocations")
                .italic()
                .opacity(0.6)
                .padding(.bottom, 20)

                StandardTextField(
                    "Income",
                    text: $viewmodel.incomeText,
                    placeholder: "e.g. 5000",
                    icon: "dollarsign.circle"
                )

                StandardTextField(
                    "Gross Target",
                    text: $viewmodel.grossTargetText,
                    placeholder: "e.g. 20000",
                    icon: "target"
                )

                Picker(
                    "Account",
                    selection: $viewmodel.selectedAccount
                ) {
                    ForEach(IncomeAllocationAccount.allCases, id: \.self) { account in
                        Text(account.rawValue).tag(account)
                    }
                }

                StandardTextField(
                    "Account Target",
                    text: $viewmodel.accountTargetText,
                    placeholder: "e.g. 5000",
                    icon: "flag"
                )

                StandardTextField(
                    "Periods",
                    text: $viewmodel.periodsText,
                    placeholder: "e.g. 12",
                    icon: "calendar"
                )
            }
            .frame(maxWidth: 200)

            Divider()

            VStack(spacing: 12) {
                Text("Allocations")
                .italic()
                .opacity(0.6)
                .padding(.bottom, 20)

                if viewmodel.allocationResults.isEmpty {
                    Text("No allocations configured")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewmodel.allocationResults, id: \.self) { line in
                        Text(line)
                    }
                }
            }

            Divider()

            VStack(spacing: 12) {
                Text("Projections")
                .italic()
                .opacity(0.6)
                .padding(.bottom, 20)

                if !viewmodel.periodsToGrossText.isEmpty {
                    Text(viewmodel.periodsToGrossText)
                }
                if !viewmodel.periodsToAccountText.isEmpty {
                    Text(viewmodel.periodsToAccountText)
                }
                if !viewmodel.projectedBalanceText.isEmpty {
                    Text(viewmodel.projectedBalanceText)
                }
            }
        }
        // .navigationTitle("")
    }
}
