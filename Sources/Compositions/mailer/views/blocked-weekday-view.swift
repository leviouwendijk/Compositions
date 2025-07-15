import Foundation
import SwiftUI
import ViewComponents
import Implementations

struct BlockedWeekdayRow: View {
    @Binding var item: BlockedWeekdayItem

    var body: some View {
        HStack(spacing: 12) {
            SelectableRow(
                title: item.weekday.dutch,
                isSelected: item.isOn,
                action: { item.isOn.toggle() }
            )
            if item.isOn {
                StandardTextField(
                    "Aantal (nil=allemaal)",
                    text: $item.limitText
                )
                .frame(width: 60)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}

public struct BlockedWeekdaysView: View {
    @ObservedObject var viewmodel: BlockedWeekdaysViewModel

    public init(viewmodel: BlockedWeekdaysViewModel) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Blokkeer dagen")
                .font(.headline)

            ForEach($viewmodel.items) { $item in
                BlockedWeekdayRow(item: $item)
            }
        }
        .padding()
    }
}
