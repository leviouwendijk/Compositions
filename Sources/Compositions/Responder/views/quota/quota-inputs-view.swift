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
    @ObservedObject public var viewmodel: QuotaViewModel

    public init(viewmodel: QuotaViewModel) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            KilometersField(
                kilometers: $viewmodel.customQuotaInputs.travelCost.kilometers
            )

            SessionPairField(
                label: "prognosis",
                count: $viewmodel.customQuotaInputs.prognosis.count,
                local: $viewmodel.customQuotaInputs.prognosis.local,
                countPlaceholder: "5",
                localPlaceholder: "4"
            )

            SessionPairField(
                label: "suggestion",
                count: $viewmodel.customQuotaInputs.suggestion.count,
                local: $viewmodel.customQuotaInputs.suggestion.local,
                countPlaceholder: "3",
                localPlaceholder: "2"
            )

            SessionPairField(
                label: "singular",
                count: $viewmodel.customQuotaInputs.singular.count,
                local: $viewmodel.customQuotaInputs.singular.local,
                countPlaceholder: "1",
                localPlaceholder: "0"
            )

            BaseField(
                base: $viewmodel.customQuotaInputs.base
            )

            TravelCostFields(
                speed: $viewmodel.customQuotaInputs.travelCost.speed,
                travelRate: Binding(
                    get: { viewmodel.customQuotaInputs.travelCost.rates.travel },
                    set: { viewmodel.customQuotaInputs.travelCost.rates.travel = $0 }
                ),
                timeRate: Binding(
                    get: { viewmodel.customQuotaInputs.travelCost.rates.time },
                    set: { viewmodel.customQuotaInputs.travelCost.rates.time = $0 }
                )
            )

            ExpirationFields(
                start: $viewmodel.customQuotaInputs.expiration.start,
                unit: $viewmodel.customQuotaInputs.expiration.unit,
                interval: $viewmodel.customQuotaInputs.expiration.interval,
                resultText: viewmodel.customQuotaInputs.expiration.result?.dates.string()
            )
        }
    }
}
