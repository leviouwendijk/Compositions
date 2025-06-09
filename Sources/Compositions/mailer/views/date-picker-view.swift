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
            // Month selector
            VStack(spacing: 0) {
                SectionTitle(title: "Months")
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
            .frame(width: 180)

            // .onChange(of: viewmodel.selectedMonth) { newMonth in
            //     viewmodel.validateDay()
            // }

            // Day selector
            VStack(spacing: 0) {
                SectionTitle(title: "Days")
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
            .frame(width: 140)

            // Hour selector
            VStack(spacing: 0) {
                SectionTitle(title: "Hours")
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
            .frame(width: 120)

            // Minute selector + Common
            VStack(spacing: 0) {
                SectionTitle(title: "Minutes")
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

                ScrollView {
                    VStack(spacing: 5) {
                        SectionTitle(title: "Common")
                            .padding(.horizontal)

                        // Common quarter-hour picks
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
            .frame(width: 120)
            
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

            Divider()

            VStack {
                Text("Appointments Queue").bold()

                if viewmodel.appointmentsQueue.isEmpty {
                    Text("No appointments added")
                        .foregroundColor(.gray)
                } else {
                    AppointmentListView()
                    // .environmentObject(viewmodel)
                }
                Spacer()

                HStack {
                    StandardButton(
                        type: .load,
                        title: "Add to Queue",
                        action: {
                            viewmodel.addToQueue()
                        },
                        image: "plus.circle.fill"
                    )

                    StandardButton(
                        type: .clear,
                        title: "Clear Queue",
                        action: {
                            viewmodel.clearQueue()
                        },
                        image: "trash.fill"
                    )
                    // Button(action: viewmodel.clearQueue) {
                    //     Label("Clear Queue", systemImage: "trash.fill")
                    //         .foregroundColor(.red)
                    // }
                    // .buttonStyle(.bordered)
                }
                .padding(.top, 10)
            }
            // .onAppear {
            //     let appt = viewmodel.createAppointment()
            //     print("created appt in view:\n", appt)
            // }
            .frame(width: 400)
        }
        .padding()
    }
}

public struct AppointmentListView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel
    @State private var localAppointments: [MailerAPIAppointmentContent] = []

    public var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(localAppointments) { appt in
                    AppointmentRow(
                        appointment: appt, 
                        onDelete: { 
                            viewmodel.removeAppointment(appt)
                        }
                    )
                }
            }
        }
        .onReceive(viewmodel.$appointmentsQueue) { newQueue in
            localAppointments = newQueue
        }
    }
}

public struct AppointmentRow: View {
    public let appointment: MailerAPIAppointmentContent
    public let onDelete: ()->Void

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("📅 \(appointment.date) (\(appointment.day))")
                Text("🕒 \(appointment.time)")
                if !appointment.street.isEmpty {
                    Text("\(appointment.street) \(appointment.number)")
                }
                if !appointment.area.isEmpty {
                    Text(appointment.area)
                }
                if !appointment.area.isEmpty {
                    Text(appointment.area)
                }
                Text("📍 \(appointment.location)")
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
