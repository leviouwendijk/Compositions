import SwiftUI
import Contacts
import EventKit
import plate
import ViewComponents
import Implementations
import Structures

public struct AppointmentsQueueView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() {}

    public var body: some View {
        VStack {
            SectionTitle(title: "Appointments Queue", fontSize: 14)
            .padding(.bottom, 20)

            if viewmodel.appointmentsQueue.isEmpty {
                Text("No appointments added")
                    .foregroundColor(.gray)
            } else {
                AppointmentListView()
            }
            Spacer()

            HStack {
                StandardButton(
                    type: .load,
                    title: "Add",
                    action: {
                        viewmodel.addToQueue()
                    },
                    appearance: ButtonAppearanceConfiguration(
                        image: "plus.circle.fill"
                    )
                )

                StandardButton(
                    type: .clear,
                    title: "Clear",
                    action: {
                        viewmodel.clearQueue()
                    },
                    appearance: ButtonAppearanceConfiguration(
                        image: "trash.fill"
                    )
                )
                // Button(action: viewmodel.clearQueue) {
                //     Label("Clear Queue", systemImage: "trash.fill")
                //         .foregroundColor(.red)
                // }
                // .buttonStyle(.bordered)
            }
            .padding(.top, 10)
        }
    }
}

public struct AppointmentListView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                if viewmodel.appointmentsQueue.isEmpty {
                    Text("No appointments added")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewmodel.appointmentsQueue) { appt in
                        AppointmentRow(
                            appointment: appt,
                            onDelete: {
                                viewmodel.removeAppointment(appt)
                            }
                        )
                    }
                }
            }
        }
    }
}

public struct AppointmentRow: View {
    public let appointment: MailerAPIAppointmentContent
    public let onDelete: ()->Void

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\( ( try? appointment.writtenDate(in: .us) ) ?? "" )")
                Label(appointment.date, systemImage: "calendar")
                Label(appointment.time, systemImage: "clock")
                if !appointment.street.isEmpty {
                    Text("\(appointment.street) \(appointment.number)")
                }
                if !appointment.area.isEmpty {
                    Text(appointment.area)
                }
                Text("\(appointment.location)")
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "x.circle.fill")
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

public struct DateOutputFormatSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            Text("Preset Formats").bold()
            Picker("Select Format", selection: $viewmodel.outputFormat) {
                Text("YYYY-MM-DD HH:mm").tag("yyyy-MM-dd HH:mm")
                Text("DD/MM/YYYY HH:mm").tag("dd/MM/yyyy HH:mm")
                Text("MM-DD-YYYY HH:mm").tag("MM-dd-yyyy HH:mm")
                Text("ISO 8601").tag("yyyy-MM-dd'T'HH:mm:ssZ")
                Text("CLI (mailer)").tag("--date dd/MM/yyyy --time HH:mm")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }
}
