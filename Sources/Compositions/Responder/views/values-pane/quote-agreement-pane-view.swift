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

            VStack {
                Text("Duration")
                HStack {
                    StandardTextField(
                        "from",
                        text: $viewmodel.fromMinutes,
                        placeholder: "60",
                    )

                    StandardTextField(
                        "to",
                        text: $viewmodel.toMinutes,
                        placeholder: "120",
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
