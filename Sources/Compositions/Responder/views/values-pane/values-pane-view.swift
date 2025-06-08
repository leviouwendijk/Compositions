import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Economics
import Implementations

public struct ValuesPaneView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    
    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            if viewmodel.apiPathVm.selectedRoute == .custom {
                CustomMessagePaneView(viewmodel: viewmodel)
            } else if viewmodel.apiPathVm.selectedRoute == .appointment {
                DatePickerView(
                    viewmodel: viewmodel
                )
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
