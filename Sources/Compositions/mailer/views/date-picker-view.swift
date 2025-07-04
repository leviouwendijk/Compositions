import SwiftUI
import Contacts
import EventKit
import plate
import ViewComponents
import Implementations
import Structures

public struct DatePickerView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        HStack {
            DateComponentSelectionView()
            // DateOutputFormatSelectionView()

            Divider()

            AppointmentsQueueView()
            .frame(width: 240)
        }
        .padding()
    }
}

public struct DateComponentSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack {
            HStack {
                MonthSelectionView()
                .frame(width: 150)

                DaySelectionView()
                // .frame(width: 100)
            }
            .frame(width: 260)

            HStack {
                HourSelectionView()
                // .frame(width: 100)

                MinuteSelectionView()
                // .frame(width: 100)
            }
            .frame(width: 260)
        }
    }
}


public struct MonthSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            SectionTitle(title: "Month", fontSize: 14)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 5) {
                    ForEach(viewmodel.months.indices, id: \.self) { idx in
                        SelectableRow(
                            title: viewmodel.months[idx],
                            isSelected: viewmodel.selectedMonth == idx + 1
                        ) {
                            viewmodel.selectedMonth = idx + 1
                            viewmodel.validateDay()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

public struct DaySelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            SectionTitle(title: "Day", fontSize: 14)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 5) {
                    ForEach(viewmodel.days, id: \.self) { day in
                        SelectableRow(
                            title: "\(day)",
                            isSelected: viewmodel.selectedDay == day
                        ) {
                            viewmodel.selectedDay = day
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

public struct HourSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            SectionTitle(title: "Hour", fontSize: 14)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 5) {
                    ForEach(viewmodel.hours, id: \.self) { hour in
                        SelectableRow(
                            title: String(format: "%02d", hour),
                            isSelected: viewmodel.selectedHour == hour
                        ) {
                            viewmodel.selectedHour = hour
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

public struct MinuteSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            SectionTitle(title: "Minute", fontSize: 14)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 5) {
                    // All minute options
                    ForEach(viewmodel.minutes, id: \.self) { minute in
                        SelectableRow(
                            title: String(format: "%02d", minute),
                            isSelected: viewmodel.selectedMinute == minute
                        ) {
                            viewmodel.selectedMinute = minute
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            SectionTitle(title: "Common", fontSize: 14)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 5) {
                    ForEach([0, 15, 30, 45], id: \.self) { minute in
                        SelectableRow(
                            title: String(format: "%02d", minute),
                            isSelected: viewmodel.selectedMinute == minute
                        ) {
                            viewmodel.selectedMinute = minute
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

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

