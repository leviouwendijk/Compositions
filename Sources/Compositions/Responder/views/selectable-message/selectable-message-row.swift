import SwiftUI
import Structures

public struct SelectableMessageRow: View {
    public let message: ReusableTextMessage

    public init(message: ReusableTextMessage) {
        self.message = message
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(message.title)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(message.details)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(minWidth: 200, alignment: .leading)
        .padding(.vertical, 4)
    }
}
