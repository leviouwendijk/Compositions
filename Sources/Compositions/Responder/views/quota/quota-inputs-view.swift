import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaInputsView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    
    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1) “Kilometers” field
            StandardTextField(
                "kilometers",
                text: Binding<String>(
                    get:  { viewmodel.quotaVm.customQuotaInputs.travelCost.kilometers },
                    set:  { newValue in
                        viewmodel.quotaVm.customQuotaInputs.travelCost.kilometers = newValue
                    }
                ),
                placeholder: "45"
            )

            // 2) Prognosis / Local
            HStack {
                StandardTextField(
                    "prognosis",
                    text: Binding<String>(
                        get:  { viewmodel.quotaVm.customQuotaInputs.prognosis.count },
                        set:  { newValue in
                            viewmodel.quotaVm.customQuotaInputs.prognosis.count = newValue
                        }
                    ),
                    placeholder: "5"
                )
                StandardTextField(
                    "local",
                    text: Binding<String>(
                        get:  { viewmodel.quotaVm.customQuotaInputs.prognosis.local },
                        set:  { newValue in
                            viewmodel.quotaVm.customQuotaInputs.prognosis.local = newValue
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
                        get:  { viewmodel.quotaVm.customQuotaInputs.suggestion.count },
                        set:  { newValue in
                            viewmodel.quotaVm.customQuotaInputs.suggestion.count = newValue
                        }
                    ),
                    placeholder: "3"
                )
                StandardTextField(
                    "local",
                    text: Binding<String>(
                        get:  { viewmodel.quotaVm.customQuotaInputs.suggestion.local },
                        set:  { newValue in
                            viewmodel.quotaVm.customQuotaInputs.suggestion.local = newValue
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
                        get:  { viewmodel.quotaVm.customQuotaInputs.singular.count },
                        set:  { newValue in
                            viewmodel.quotaVm.customQuotaInputs.singular.count = newValue
                        }
                    ),
                    placeholder: "1"
                )
                StandardTextField(
                    "local",
                    text: Binding<String>(
                        get:  { viewmodel.quotaVm.customQuotaInputs.singular.local },
                        set:  { newValue in
                            viewmodel.quotaVm.customQuotaInputs.singular.local = newValue
                        }
                    ),
                    placeholder: "0"
                )
            }


            // 4) Base
            StandardTextField(
                "base",
                text: Binding<String>(
                    get:  { viewmodel.quotaVm.customQuotaInputs.base },
                    set:  { newValue in
                        viewmodel.quotaVm.customQuotaInputs.base = newValue
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
                            get:  { viewmodel.quotaVm.customQuotaInputs.travelCost.speed },
                            set:  { newValue in
                                viewmodel.quotaVm.customQuotaInputs.travelCost.speed = newValue
                            }
                        ),
                        placeholder: "80.0"
                    )
                    StandardTextField(
                        "rate/travel",
                        text: Binding<String>(
                            get:  { viewmodel.quotaVm.customQuotaInputs.travelCost.rates.travel },
                            set:  { newValue in
                                viewmodel.quotaVm.customQuotaInputs.travelCost.rates = TravelCostRatesInputs(
                                    travel: newValue,
                                    time: viewmodel.quotaVm.customQuotaInputs.travelCost.rates.time
                                )
                            }
                        ),
                        placeholder: "0.25"
                    )
                    StandardTextField(
                        "rate/time",
                        text: Binding<String>(
                            get:  { viewmodel.quotaVm.customQuotaInputs.travelCost.rates.time },
                            set:  { newValue in
                                viewmodel.quotaVm.customQuotaInputs.travelCost.rates = TravelCostRatesInputs(
                                    travel: viewmodel.quotaVm.customQuotaInputs.travelCost.rates.travel,
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
        .frame(maxHeight: .infinity)
    }
}
