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
                "Sessions left to schedule",
                text: $viewmodel.sessionCount,
                placeholder: "e.g., 1, 3, 4",
            )

            StandardToggle(
                isOn: $viewmodel.includeReflection,
                title: "Include reflection opening remark"
            )
            Text("Prepends: \"Hopelijk beviel jouw afgelopen sessie\"")
            .foregroundStyle(.secondary)

            
            BlockedWeekdaysView(viewmodel: viewmodel.blockedWeekdaysVm)
        }
    }
}
