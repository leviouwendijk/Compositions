// import Foundation
// import plate
// import SwiftUI 
// import Implementations
// import Structures

// @available(*, message: "Use SelectableMessageDropdown instead.")
// public struct WAMessageDropdown: View {
//     @Binding public var selected: WAMessageTemplate
//     @State public var isExpanded: Bool = false

//     public let labelWidth: CGFloat
//     public let maxListHeight: CGFloat

//     public init(
//         selected: Binding<WAMessageTemplate>,
//         labelWidth: CGFloat = 200,
//         maxListHeight: CGFloat = 200
//     ) {
//         self._selected = selected
//         self.labelWidth = labelWidth
//         self.maxListHeight = maxListHeight
//     }

//     public var body: some View {
//         ZStack(alignment: .topLeading) {
//             Button(action: {
//                 withAnimation(.easeInOut(duration: 0.2)) {
//                     isExpanded.toggle()
//                 }
//             }) {
//                 HStack(spacing: 0) {
//                     VStack(alignment: .leading, spacing: 2) {
//                         Text(selected.title)
//                             .lineLimit(1)
//                             .truncationMode(.tail)

//                         Text(selected.subtitle)
//                             .font(.caption)
//                             .foregroundColor(.secondary)
//                             .lineLimit(1)
//                             .truncationMode(.tail)
//                     }

//                     Spacer()

//                     Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                         .font(.system(size: 13, weight: .semibold))
//                         .foregroundColor(.gray)
//                 }
//                 .padding(.vertical, 6)
//                 .frame(minWidth: labelWidth, alignment: .leading)
//             }
//             .contentShape(Rectangle())
//             .background(
//                 RoundedRectangle(cornerRadius: 6)
//                     .stroke(Color.secondary.opacity(0.6), lineWidth: 2)
//             )

//             if isExpanded {
//                 VStack(spacing: 0) {
//                     ScrollView {
//                         VStack(spacing: 0) {
//                             ForEach(WAMessageTemplate.allCases, id: \.self) { template in
//                                 Button(action: {
//                                     withAnimation(.easeInOut(duration: 0.2)) {
//                                         selected = template
//                                         isExpanded = false
//                                     }
//                                 }) {
//                                     WAMessageRow(template: template)
//                                 }
//                                 .padding(.vertical, 2)
//                                 .disabled((template == selected))
//                             }
//                         }
//                     }
//                     .frame(maxHeight: maxListHeight)
//                 }
//                 // .background(
//                 //     RoundedRectangle(cornerRadius: 8)
//                 //         .fill(Color(NSColor.windowBackgroundColor))
//                 //         .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//                 // )
//                 .offset(y: 44)
//                 .zIndex(1)
//                 .fixedSize(horizontal: false, vertical: true)
//                 // .padding(.vertical, 10)
//                 .padding(.top, 6)
//             }
//         }
//     }
// }
