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
        ScrollView {
            VStack {
                if viewmodel.apiPathVm.selectedRoute == .custom {
                    CustomMessagePaneView()
                    // .environmentObject(viewmodel)
                } else if viewmodel.apiPathVm.selectedRoute == .appointment && !(viewmodel.apiPathVm.selectedEndpoint == .availabilityRequest) {
                    DatePickerView()
                    // .environmentObject(viewmodel)
                } else if viewmodel.apiPathVm.selectedRoute == .appointment && viewmodel.apiPathVm.selectedEndpoint == .availabilityRequest {
                    AppointmentAvailabilityPaneView()
                    .frame(maxWidth: 350)
                } else  if (viewmodel.apiPathVm.selectedRoute == .quote && viewmodel.apiPathVm.selectedEndpoint?.base == .agreement) {
                    QuoteAgreementPaneView()
                    .frame(maxWidth: 350)
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
}
