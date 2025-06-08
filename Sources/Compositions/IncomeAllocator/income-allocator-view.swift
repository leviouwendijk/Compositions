import SwiftUI
import Combine
import plate
import ViewComponents
import Economics
import Implementations

public struct IncomeAllocatorView: View {
    @StateObject private var viewModel = IncomeAllocatorViewModel()

    public init() {}

    public var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                Text("Allocations")
                .italic()
                .opacity(0.6)
                .padding(.bottom, 20)

                StandardTextField(
                    "Income",
                    text: $viewModel.incomeText,
                    placeholder: "e.g. 5000",
                    icon: "dollarsign.circle"
                )

                StandardTextField(
                    "Gross Target",
                    text: $viewModel.grossTargetText,
                    placeholder: "e.g. 20000",
                    icon: "target"
                )

                Picker(
                    "Account",
                    selection: $viewModel.selectedAccount
                ) {
                    ForEach(IncomeAllocationAccount.allCases, id: \.self) { account in
                        Text(account.rawValue).tag(account)
                    }
                }

                StandardTextField(
                    "Account Target",
                    text: $viewModel.accountTargetText,
                    placeholder: "e.g. 5000",
                    icon: "flag"
                )

                StandardTextField(
                    "Periods",
                    text: $viewModel.periodsText,
                    placeholder: "e.g. 12",
                    icon: "calendar"
                )
            }

            Divider()

            VStack(spacing: 12) {
                Text("Allocations")
                .italic()
                .opacity(0.6)
                .padding(.bottom, 20)

                if viewModel.allocationResults.isEmpty {
                    Text("No allocations configured")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.allocationResults, id: \.self) { line in
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

                if !viewModel.periodsToGrossText.isEmpty {
                    Text(viewModel.periodsToGrossText)
                }
                if !viewModel.periodsToAccountText.isEmpty {
                    Text(viewModel.periodsToAccountText)
                }
                if !viewModel.projectedBalanceText.isEmpty {
                    Text(viewModel.projectedBalanceText)
                }
            }
        }
        .navigationTitle("Income Allocator")
    }
}
