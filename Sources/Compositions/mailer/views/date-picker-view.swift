import SwiftUI
import Contacts
import EventKit
import plate
import ViewComponents
import Implementations
import Structures

public struct DatePickerView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    
    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

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
            
                // Text("Preset Formats").bold()
                // Picker("Select Format", selection: $outputFormat) {
                //     Text("YYYY-MM-DD HH:mm").tag("yyyy-MM-dd HH:mm")
                //     Text("DD/MM/YYYY HH:mm").tag("dd/MM/yyyy HH:mm")
                //     Text("MM-DD-YYYY HH:mm").tag("MM-dd-yyyy HH:mm")
                //     Text("ISO 8601").tag("yyyy-MM-dd'T'HH:mm:ssZ")
                //     Text("CLI (mailer)").tag("--date dd/MM/yyyy --time HH:mm")
                // }
                // .pickerStyle(MenuPickerStyle())
                // .padding()

            Divider()

            VStack {
                Text("Appointments Queue").bold()

                if viewmodel.appointmentsQueue.isEmpty {
                    Text("No appointments added")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        ForEach(viewmodel.appointmentsQueue) { appt in
                            AppointmentRow(appointment: appt) {
                                viewmodel.removeAppointment(appt)
                            }
                        }
                    }
                }
                Spacer()

                HStack {
                    Button(action: viewmodel.addToQueue) {
                        Label("Add to Queue", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)

                    Button(action: viewmodel.clearQueue) {
                        Label("Clear Queue", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 10)
            }
            .frame(width: 400)
        }
        .padding()
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
