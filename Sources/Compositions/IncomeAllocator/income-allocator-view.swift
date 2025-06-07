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
        Form {
            Section(header: Text("Income & Targets")) {
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

            Section(header: Text("Allocations")) {
                if viewModel.allocationResults.isEmpty {
                    Text("No allocations configured")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.allocationResults, id: \.self) { line in
                        Text(line)
                    }
                }
            }

            Section(header: Text("Projections")) {
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
