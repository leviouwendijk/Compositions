import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations
import Structures

public struct QuotaInputsView: View {
    @ObservedObject public var viewmodel: QuotaViewModel
    
    public init(
        viewmodel: QuotaViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1) “Kilometers” field
            StandardTextField(
                "kilometers",
                text: $viewmodel.customQuotaInputs.travelCost.kilometers,
                placeholder: "45"
            )

            // 2) Prognosis / Local
            HStack {
                StandardTextField(
                    "prognosis",
                    text: $viewmodel.customQuotaInputs.prognosis.count,
                    placeholder: "5"
                )
                StandardTextField(
                    "local",
                    text: $viewmodel.customQuotaInputs.prognosis.local,
                    placeholder: "4"
                )
            }

            // 3) Suggestion / Local
            HStack {
                StandardTextField(
                    "suggestion",
                    text: $viewmodel.customQuotaInputs.suggestion.count,
                    placeholder: "3"
                )
                StandardTextField(
                    "local",
                    text: $viewmodel.customQuotaInputs.suggestion.local,
                    placeholder: "2"
                )
            }

            // Singular / Local
            HStack {
                StandardTextField(
                    "singular",
                    text: $viewmodel.customQuotaInputs.singular.count,
                    placeholder: "1"
                )
                StandardTextField(
                    "local",
                    text: $viewmodel.customQuotaInputs.singular.local,
                    placeholder: "0"
                )
            }


            // 4) Base
            StandardTextField(
                "base",
                text: $viewmodel.customQuotaInputs.base,
                placeholder: "350"
            )

            // 5) Travel‐cost fields
            VStack(alignment: .leading, spacing: 8) {
                // Text("Travel Cost Inputs").bold()
                HStack {
                    StandardTextField(
                        "speed",
                        text: $viewmodel.customQuotaInputs.travelCost.speed,
                        placeholder: "80.0"
                    )
                    StandardTextField(
                        "rate/travel",
                        text: Binding<String>(
                            get:  { viewmodel.customQuotaInputs.travelCost.rates.travel },
                            set:  { newValue in
                                viewmodel.customQuotaInputs.travelCost.rates = TravelCostRatesInputs(
                                    travel: newValue,
                                    time: viewmodel.customQuotaInputs.travelCost.rates.time
                                )
                            }
                        ),
                        placeholder: "0.25"
                    )
                    StandardTextField(
                        "rate/time",
                        text: Binding<String>(
                            get:  { viewmodel.customQuotaInputs.travelCost.rates.time },
                            set:  { newValue in
                                viewmodel.customQuotaInputs.travelCost.rates = TravelCostRatesInputs(
                                    travel: viewmodel.customQuotaInputs.travelCost.rates.travel,
                                    time: newValue
                                )
                            }
                        ),
                        placeholder: "105"
                    )
                }
            }
            .padding(.top, 8)

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                DatePicker(
                    "",
                    selection: $viewmodel.customQuotaInputs.expiration.start,
                    displayedComponents: .date
                )
                .datePickerStyle(DefaultDatePickerStyle())

                EnumDropdown<DateDistanceUnit>(
                    selected: $viewmodel.customQuotaInputs.expiration.unit,
                    labelWidth: 100,
                    maxListHeight: 150
                )

                StandardTextField(
                    "interval",
                    text: $viewmodel.customQuotaInputs.expiration.interval,
                    placeholder: "4"
                )
                .frame(width: 65)
            }
            .padding(.top, 8)

        }
    }
}
