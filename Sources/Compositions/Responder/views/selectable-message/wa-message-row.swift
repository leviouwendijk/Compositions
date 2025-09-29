import Foundation
import plate
import SwiftUI 
import Implementations
import Structures

@available(*, message: "Use SelectableMessageRow instead.")
public struct WAMessageRow: View {
    public let template: WAMessageTemplate

    public init(
        template: WAMessageTemplate
    ) {
        self.template = template
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(template.title)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(template.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(minWidth: 200, alignment: .leading)
        .padding(.vertical, 4)
    }
}
