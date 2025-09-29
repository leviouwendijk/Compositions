import SwiftUI
import Structures

public struct SelectableMessageRow: View {
    public let message: ReusableTextMessageObject

    public init(message: ReusableTextMessageObject) {
        self.message = message
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(message.object.title)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(message.object.details)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(minWidth: 200, alignment: .leading)
        .padding(.vertical, 4)
    }
}
