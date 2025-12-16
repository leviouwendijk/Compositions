import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations
import Structures
import Extensions

struct KilometersField: View {
    @Binding var kilometers: String
    var body: some View {
        StandardTextField(
            "kilometers",
            text: $kilometers,
            placeholder: "45"
        )
    }
}

struct SessionPairField: View {
    let label: String
    @Binding var count: String
    @Binding var local: String
    var countPlaceholder: String
    var localPlaceholder: String

    var body: some View {
        HStack {
            StandardTextField(
                label,
                text: $count,
                placeholder: countPlaceholder
            )
            StandardTextField(
                "local",
                text: $local,
                placeholder: localPlaceholder
            )
        }
    }
}

struct BaseField: View {
    @Binding var base: String
    var body: some View {
        StandardTextField(
            "base",
            text: $base,
            placeholder: "350"
        )
    }
}

struct TravelCostFields: View {
    @Binding var speed: String
    @Binding var travelRate: String
    @Binding var timeRate: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                StandardTextField(
                    "speed",
                    text: $speed,
                    placeholder: "80.0"
                )
                StandardTextField(
                    "rate/travel",
                    text: $travelRate,
                    placeholder: "0.25"
                )
                StandardTextField(
                    "rate/time",
                    text: $timeRate,
                    placeholder: "105"
                )
            }
        }
        .padding(.top, 8)
    }
}

struct ExpirationFields: View {
    @Binding var start: Date
    @Binding var unit: DateDistanceUnit
    @Binding var interval: String
    var resultText: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                DatePicker(
                    "",
                    selection: $start,
                    displayedComponents: .date
                )
                .datePickerStyle(DefaultDatePickerStyle())

                EnumDropdown<DateDistanceUnit>(
                    selected: $unit,
                    labelWidth: 100,
                    maxListHeight: 150
                )
            }

            StandardTextField(
                "interval count",
                text: $interval,
                placeholder: "4"
            )
            .frame(width: 80)

            if let rangeString = resultText {
                Text(rangeString)
            }
        }
        .padding(.top, 8)
    }
}

public struct QuotaInputsView: View {
    @ObservedObject var viewmodel: QuotaViewModel

    private let debounce: Int = 250

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Kilometers
            DebouncedField(
                label: "kilometers",
                text: viewmodel.inputsVm.customQuotaInputs.travelCost.kilometers,
                placeholder: "45",
                debounce: debounce
            ) { new in
                viewmodel.inputsVm.customQuotaInputs.travelCost.kilometers = new
            }

            // Prognosis / Local
            HStack {
                DebouncedField(
                    label: "prognosis",
                    text: viewmodel.inputsVm.customQuotaInputs.prognosis.count,
                    placeholder: "5",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.prognosis.count = new
                }
                DebouncedField(
                    label: "local",
                    text: viewmodel.inputsVm.customQuotaInputs.prognosis.local,
                    placeholder: "4",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.prognosis.local = new
                }
            }

            // suggestion / local
            HStack {
                DebouncedField(
                    label: "suggestion",
                    text: viewmodel.inputsVm.customQuotaInputs.suggestion.count,
                    placeholder: "3",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.suggestion.count = new
                }
                DebouncedField(
                    label: "local",
                    text: viewmodel.inputsVm.customQuotaInputs.suggestion.local,
                    placeholder: "2",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.suggestion.local = new
                }
            }

            // singular / local
            HStack {
                DebouncedField(
                    label: "singular",
                    text: viewmodel.inputsVm.customQuotaInputs.singular.count,
                    placeholder: "1",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.singular.count = new
                }
                DebouncedField(
                    label: "local",
                    text: viewmodel.inputsVm.customQuotaInputs.singular.local,
                    placeholder: "0",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.singular.local = new
                }
            }

            // base
            DebouncedField(
                label: "base",
                text: viewmodel.inputsVm.customQuotaInputs.base,
                placeholder: "350",
                debounce: debounce
            ) { new in
                viewmodel.inputsVm.customQuotaInputs.base = new
            }

            // speed / rate fields
            HStack(spacing: 12) {
                DebouncedField(
                    label: "speed",
                    text: viewmodel.inputsVm.customQuotaInputs.travelCost.speed,
                    placeholder: "80.0",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.travelCost.speed = new
                }

                DebouncedField(
                    label: "rate/travel",
                    text: viewmodel.inputsVm.customQuotaInputs.travelCost.rates.travel,
                    placeholder: "0.25",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.travelCost.rates.travel = new
                }

                DebouncedField(
                    label: "rate/time",
                    text: viewmodel.inputsVm.customQuotaInputs.travelCost.rates.time,
                    placeholder: "105",
                    debounce: debounce
                ) { new in
                    viewmodel.inputsVm.customQuotaInputs.travelCost.rates.time = new
                }
            }
            .padding(.top, 8)

            // expiration
            ExpirationFields(
                start: $viewmodel.inputsVm.customQuotaInputs.expiration.start,
                unit: $viewmodel.inputsVm.customQuotaInputs.expiration.unit,
                interval: $viewmodel.inputsVm.customQuotaInputs.expiration.interval,
                // resultText: viewmodel.inputsVm.customQuotaInputs.expiration.result?.dates.string()
                resultText: viewmodel.inputsVm.customQuotaInputs.expiration.result?.string()
            )
        }
        .padding()
    }
}
