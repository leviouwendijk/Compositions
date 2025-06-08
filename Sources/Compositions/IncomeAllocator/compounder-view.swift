import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct CompounderView: View {
    @StateObject public var viewmodel: CompounderViewModel

    public init(viewmodel: CompounderViewModel? = nil) {
        _viewmodel = StateObject(wrappedValue: viewmodel ?? CompounderViewModel())
    }

    public var body: some View {
        VStack {
            VStack {
                SectionTitle(title: "Compound Settings") 

                StandardTextField(
                    "Principal",
                    text: $viewmodel.principalText,
                    placeholder: "e.g. 1000",
                    icon: "eurosign.circle"
                )

                StandardTextField(
                    "Annual Rate %",
                    text: $viewmodel.annualRateText,
                    placeholder: "e.g. 5",
                    icon: "percent"
                )

                StandardTextField(
                    "Monthly Investment",
                    text: $viewmodel.monthlyInvestmentText,
                    placeholder: "e.g. 100",
                    icon: "calendar.badge.plus"
                )

                StandardTextField(
                    "Years",
                    text: $viewmodel.yearsText,
                    placeholder: "e.g. 10",
                    icon: "clock"
                )

                Toggle(
                    "Rounding",
                    isOn: $viewmodel.rounding
                )

                Picker(
                    "Calculation Time",
                    selection: $viewmodel.calculationTime
                ) {
                    ForEach(CompoundTime.allCases) { option in
                        Text(option.rawValue.capitalized).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            VStack {
                SectionTitle(title: "Results") 

                if !viewmodel.totalInvestedText.isEmpty {
                    Text(viewmodel.totalInvestedText)
                }
                if !viewmodel.finalValueText.isEmpty {
                    Text(viewmodel.finalValueText)
                }
                if !viewmodel.totalReturnText.isEmpty {
                    Text(viewmodel.totalReturnText)
                }
            }
        }
        // .navigationTitle("Compound Calculator")
    }
}
