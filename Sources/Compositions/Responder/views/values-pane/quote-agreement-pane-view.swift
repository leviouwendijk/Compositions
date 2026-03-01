import SwiftUI
import Foundation
import ViewComponents
import Implementations
import Structures

public struct QuoteAgreementPaneView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            StandardTextField(
                "Deliverable",
                text: $viewmodel.deliverable,
                placeholder: "Geadviseerde sessie-aantal, Puppy-pakket",
            )

            StandardTextField(
                "Session Count",
                text: $viewmodel.sessions,
                placeholder: "3, 5, 7",
            )

            StandardToggle(
                style: .switch,
                isOn: $viewmodel.includeQuoteOverride,
                title: "(Old): Include last generated quote",
                subtitle: nil,
                // width: 150
            )

            StandardToggle(
                style: .switch,
                isOn: $viewmodel.includeProgramOverride,
                title: "Include last generated program",
                subtitle: nil
            )

            VStack {
                Text("Duration")
                HStack {
                    StandardTextField(
                        "from",
                        text: $viewmodel.fromMinutes,
                        placeholder: "30, 45, 60 (default: \(AgreementDeliverableSessionDurationRange().fromMinutes))"
                        // placeholder: "\(viewmodel.fromMinutes)"
                        // placeholder: "\(viewmodel.fromMinutes)"
                    )

                    StandardTextField(
                        "to",
                        text: $viewmodel.toMinutes,
                        placeholder: "60, 90, 120 (default: \(AgreementDeliverableSessionDurationRange().toMinutes))"
                        // placeholder: "\(viewmodel.toMinutes)"
                    )
                }
            }

            StandardTextField(
                "Price",
                text: $viewmodel.price,
                placeholder: "1245",
            )
        }
    }
}
