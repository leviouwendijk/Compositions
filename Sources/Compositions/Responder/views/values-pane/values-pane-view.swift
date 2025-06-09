import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Economics
import Implementations

public struct ValuesPaneView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    public init() {}

    public var body: some View {
        VStack {
            if viewmodel.apiPathVm.selectedRoute == .custom {
                CustomMessagePaneView(viewmodel: viewmodel)
            } else if viewmodel.apiPathVm.selectedRoute == .appointment {
                DatePickerView()
                .environmentObject(viewmodel)
            } else {
                if viewmodel.apiPathVm.endpointNeedsAvailabilityVariable {
                    VStack(alignment: .leading, spacing: 8) {
                        WeeklyScheduleView(viewModel: viewmodel.weeklyScheduleVm)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
