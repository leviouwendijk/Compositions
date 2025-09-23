import SwiftUI
import Contacts
import EventKit
import plate
import ViewComponents
import Implementations
import Structures

public struct DateAppointmentPickerView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        HStack {
            DatePickerView()

            Divider()

            AppointmentsQueueView()
            // .frame(width: 240)
            // DEPRECATE FORCED WIDTH
            .frame(maxWidth: 240)
            // only enforce a maximum

            // DateOutputFormatSelectionView()
        }
        .padding()
    }
}
