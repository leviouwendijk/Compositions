import Foundation
import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaTableView: View {
    @ObservedObject public var viewmodel: QuotaViewModel

    public init (
        viewmodel: QuotaViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            if let tiers = viewmodel.tiers {
                HStack(alignment: .top, spacing: 4) {
                    LabelColumnView()
                        .frame(width: 80)
                    ForEach(tiers, id: \.tier) { t in
                        TierColumnView(
                          content: t,
                          isSelected: (viewmodel.selectedTier == t.tier)
                        )
                        .onTapGesture { viewmodel.selectedTier = t.tier }
                    }
                }
                .padding()
            }
        }
    }
}

public struct SelectableColumn<Content: View>: View {
    public let isSelected: Bool
    public let cornerRadius: CGFloat
    public let lineWidth: CGFloat
    public let content: () -> Content

    public init(
        isSelected: Bool,
        cornerRadius: CGFloat = 8,
        lineWidth: CGFloat = 2,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.content = content
    }

    public var body: some View {
        content()
          .padding(4)
          .background(Color(NSColor.windowBackgroundColor))
          .cornerRadius(cornerRadius)
          .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
              .stroke(isSelected ? Color.accentColor : Color.clear,
                      lineWidth: lineWidth)
          )
          .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

public struct TierColumnView: View {
    public let content: QuotaTierContent
    public var isSelected: Bool

    public var body: some View {
        SelectableColumn(isSelected: isSelected) {
            VStack(spacing: 0) {
                // — Header —
                Text(content.tier.rawValue.capitalized)
                  .font(.subheadline).bold()
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 8)

                Divider()

                // — Price rows —
                ForEach(content.levels.viewableTuples(of: .price), id: \.0) { label, value in
                    HStack {
                        Text(label)
                          .font(.caption)
                        Spacer()
                        Text(String(format: "%.2f", value))
                          .font(.caption)
                    }
                    .padding(.vertical, 2)
                }

                Divider()

                // — Cost rows —
                ForEach(content.levels.viewableTuples(of: .cost), id: \.0) { label, value in
                    HStack {
                        Text(label)
                          .font(.caption)
                          .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.2f", value))
                          .font(.caption)
                          .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }

                Divider()

                // — Base rows —
                ForEach(content.levels.viewableTuples(of: .base), id: \.0) { label, value in
                    HStack {
                        Text(label)
                          .font(.caption)
                          .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.2f", value))
                          .font(.caption)
                          .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}

public struct LabelColumnView: View {
    private let rates: [QuotaRateType] = [.price, .cost, .base]
    public init() {}

    public var body: some View {
        SelectableColumn(isSelected: false) {
            VStack(spacing: 0) {
                Text("")
                    .font(.subheadline).bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                Divider()

                ForEach(rates.indices, id: \.self) { blockIndex in
                    ForEach(["prognosis", "suggestion", "singular"], id: \.self) { rowLabel in
                        Text(rowLabel)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 2)
                    }
                    if blockIndex < rates.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }
}
