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
        if viewmodel.pickerMode {
            HStack {
                DateComponentSelectionView()
            }
            // .frame(width: 260)
        } else {
            VStack {
                DateComponentSelectionView()
            }
            // .frame(width: 260)
        }
    }
}

public struct DateComponentSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        YearSelectionView()

        HStack {
            MonthSelectionView()
            // .frame(width: 150)

            DaySelectionView()
            // .frame(width: 100)
        }
        // .frame(width: 260)

        HStack {
            HourSelectionView()
            // .frame(width: 100)

            MinuteSelectionView()
            // .frame(width: 100)
        }
        // .frame(width: 260)
    }
}

public struct YearSelectionView: View {
    @EnvironmentObject public var viewmodel: ResponderViewModel

    public init() { }

    public var body: some View {
        VStack(spacing: 0) {
            SectionTitle(title: "Year", fontSize: 14)
                .padding(.horizontal)

            HStack {
                Button {
                    viewmodel.year -= 1
                } label: {
                    Image(systemName: "chevron.left")
                }

                Text("\(viewmodel.year)")
                    .frame(minWidth: 60)

                Button {
                    viewmodel.year += 1
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
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
