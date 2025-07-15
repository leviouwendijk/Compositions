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
                SimpleTextField(
                    "limit",
                    text: $item.limitText,
                    hideLabel: true
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
            Text("Blocked days")
                .font(.headline)

            ForEach(viewmodel.items.indices, id: \.self) { idx in
                BlockedWeekdayRow(item: self.$viewmodel.items[idx])
            }
        }
        .padding()
    }
}
