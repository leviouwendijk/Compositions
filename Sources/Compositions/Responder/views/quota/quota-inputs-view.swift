import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

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
                    text: Binding<String>(
                        get:  { viewmodel.customQuotaInputs.prognosis.count },
                        set:  { newValue in
                            viewmodel.customQuotaInputs.prognosis.count = newValue
                        }
                    ),
                    placeholder: "5"
                )
                StandardTextField(
                    "local",
                    text: Binding<String>(
                        get:  { viewmodel.customQuotaInputs.prognosis.local },
                        set:  { newValue in
                            viewmodel.customQuotaInputs.prognosis.local = newValue
                        }
                    ),
                    placeholder: "4"
                )
            }

            // 3) Suggestion / Local
            HStack {
                StandardTextField(
                    "suggestion",
                    text: Binding<String>(
                        get:  { viewmodel.customQuotaInputs.suggestion.count },
                        set:  { newValue in
                            viewmodel.customQuotaInputs.suggestion.count = newValue
                        }
                    ),
                    placeholder: "3"
                )
                StandardTextField(
                    "local",
                    text: Binding<String>(
                        get:  { viewmodel.customQuotaInputs.suggestion.local },
                        set:  { newValue in
                            viewmodel.customQuotaInputs.suggestion.local = newValue
                        }
                    ),
                    placeholder: "2"
                )
            }

            // Singular / Local
            HStack {
                StandardTextField(
                    "singular",
                    text: Binding<String>(
                        get:  { viewmodel.customQuotaInputs.singular.count },
                        set:  { newValue in
                            viewmodel.customQuotaInputs.singular.count = newValue
                        }
                    ),
                    placeholder: "1"
                )
                StandardTextField(
                    "local",
                    text: Binding<String>(
                        get:  { viewmodel.customQuotaInputs.singular.local },
                        set:  { newValue in
                            viewmodel.customQuotaInputs.singular.local = newValue
                        }
                    ),
                    placeholder: "0"
                )
            }


            // 4) Base
            StandardTextField(
                "base",
                text: Binding<String>(
                    get:  { viewmodel.customQuotaInputs.base },
                    set:  { newValue in
                        viewmodel.customQuotaInputs.base = newValue
                    }
                ),
                placeholder: "350"
            )

            // 5) Travel‐cost fields
            VStack(alignment: .leading, spacing: 8) {
                // Text("Travel Cost Inputs").bold()
                HStack {
                    StandardTextField(
                        "speed",
                        text: Binding<String>(
                            get:  { viewmodel.customQuotaInputs.travelCost.speed },
                            set:  { newValue in
                                viewmodel.customQuotaInputs.travelCost.speed = newValue
                            }
                        ),
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
        }
    }
}
