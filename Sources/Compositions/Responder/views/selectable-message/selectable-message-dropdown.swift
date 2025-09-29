import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Implementations
import Structures

public struct SelectableMessageDropdown: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    @State public var isExpanded: Bool = false

    public let labelWidth: CGFloat
    public let maxListHeight: CGFloat

    public init(
        labelWidth: CGFloat = 200,
        maxListHeight: CGFloat = 200
    ) {
        self.labelWidth = labelWidth
        self.maxListHeight = maxListHeight
    }

    private var selectedMessage: ReusableTextMessageObject? {
        guard let key = viewmodel.selectedMessageKey else { return nil }
        return viewmodel.messagesStore.messages.first { $0.key == key }
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        if let msg = selectedMessage {
                            Text(msg.object.title)
                                .lineLimit(1)
                                .truncationMode(.tail)

                            Text(msg.object.details)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        } else {
                            Text("No message selected")
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
                .frame(minWidth: labelWidth, alignment: .leading)
            }
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.secondary.opacity(0.6), lineWidth: 2)
            )

            if isExpanded {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewmodel.messagesStore.messages, id: \.key) { msg in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        viewmodel.selectedMessageKey = msg.key
                                        isExpanded = false
                                    }
                                }) {
                                    SelectableMessageRow(message: msg)
                                }
                                .padding(.vertical, 2)
                                // .disabled(msg.key == viewmodel.selectedMessageKey)
                                .disabled(viewmodel.selectedMessageKey == Optional(msg.key))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .frame(maxHeight: maxListHeight)
                }
                .offset(y: 44)
                .zIndex(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 6)
            }
        }
    }
}
