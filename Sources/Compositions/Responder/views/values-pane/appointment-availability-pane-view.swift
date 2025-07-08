import SwiftUI
import Foundation
import ViewComponents
import Implementations
import Structures

public struct AppointmentAvailabilityPaneView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            StandardTextField(
                "Sessions",
                text: $viewmodel.sessionCount,
                placeholder: "1, 3, 4 schedulable sessions",
            )

            StandardToggle(
                isOn: $viewmodel.includeReflection,
                title: "Including reflection"
            )
        }
    }
}
