import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Economics
import Implementations

@MainActor
fileprivate func isAppt(_ viewmodel: ResponderViewModel) -> Bool {
    return viewmodel.apiPathVm.selectedRoute == .appointment
}

@MainActor
fileprivate func isAvailReq(_ viewmodel: ResponderViewModel) -> Bool {
    return viewmodel.apiPathVm.selectedEndpoint == .init(base: .availability, sub: .request, method: .post)
}

public struct ValuesPaneView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    public init() {}

    public var body: some View {
        VStack {
            if viewmodel.apiPathVm.selectedRoute == .custom {
                CustomMessagePaneView()
            // } else if viewmodel.apiPathVm.selectedRoute == .appointment && !(viewmodel.apiPathVm.selectedEndpoint == .availabilityRequest) {
            } else if viewmodel.apiPathVm.selectedRoute == .appointment {
                if isAvailReq(viewmodel) {
                    AppointmentAvailabilityPaneView()
                    .frame(maxWidth: 350)
                } else {
                    DateAppointmentPickerView()
                }
            // } else if viewmodel.apiPathVm.selectedRoute == .appointment && viewmodel.apiPathVm.selectedEndpoint == .init(base: .availability, sub: .request, method: .post) {
            //     AppointmentAvailabilityPaneView()
            //     .frame(maxWidth: 350)
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
