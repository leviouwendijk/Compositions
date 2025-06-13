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
                    .frame(width: 100)

                    ForEach(tiers, id: \.tier) { t in
                        TierColumnView(
                            content: t,
                            isSelected: (viewmodel.selectedTier == t.tier)
                        )
                        .onTapGesture { 
                            withAnimation {
                                if viewmodel.selectedTier == t.tier {
                                    viewmodel.selectedTier = nil
                                } else {
                                    viewmodel.selectedTier = t.tier 
                                }
                            }
                        }
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
    public let contentPadding: CGFloat  
    public let content: () -> Content

    public init(
        isSelected: Bool,
        cornerRadius: CGFloat = 8,
        lineWidth: CGFloat = 2,
        contentPadding: CGFloat = 12,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.contentPadding = contentPadding
        self.content = content
    }

    public var body: some View {
        content()
        .padding(contentPadding)
        .background(
            isSelected ? Color.accentColor.opacity(0.1) : Color(NSColor.windowBackgroundColor)
        )
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: lineWidth)
        )
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

public struct TierColumnView: View {
    public let content: QuotaTierContent
    public var isSelected: Bool
    public let showLabels: Bool
    
    public init(
        content: QuotaTierContent,
        isSelected: Bool,
        showLabels: Bool = false
    ) {
        self.content = content
        self.isSelected = isSelected
        self.showLabels = showLabels
    }

    public var body: some View {
        SelectableColumn(isSelected: isSelected) {
            VStack(spacing: 0) {
                // — Header —
                Text(content.tier.rawValue.capitalized)
                  // .font(.subheadline).bold()
                  .bold()
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 8)
                  .opacity(0.8)

                HStack {
                    VStack {
                        Text("Suggestion")
                        .italic()
                        .padding(.bottom, 8)
                        .font(.caption)

                        Text("\(content.levels.prognosis.estimation.local) in Alkmaar")
                        .font(.caption)

                        Text("\(content.levels.prognosis.estimation.remote) huisbezoeken")
                        .font(.caption)
                    }

                    VStack {
                        Text("Prognosis")
                        .italic()
                        .padding(.bottom, 8)
                        .font(.caption)

                        Text("\(content.levels.prognosis.estimation.local) in Alkmaar")
                        .font(.caption)

                        Text("\(content.levels.prognosis.estimation.remote) huisbezoeken")
                        .font(.caption)
                    }
                }
                .opacity(0.8)
                .padding(.bottom, 8)

                Divider()

                // — Price rows —
                ForEach(content.levels.viewableTuples(of: .price), id: \.0) { label, value in
                    HStack {
                        if showLabels {
                            Text(label)
                              .font(.tableLine)
                        }
                        Spacer()
                        Text(String(format: "%.2f", value))
                          .font(.tableLine)
                    }
                    .padding(.vertical, 2)
                }

                Divider()

                // — Cost rows —
                ForEach(content.levels.viewableTuples(of: .cost), id: \.0) { label, value in
                    HStack {
                        if showLabels {
                            Text(label)
                              .font(.tableLine)
                              .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(String(format: "%.2f", value))
                          .font(.tableLine)
                          .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }

                Divider()

                // — Base rows —
                ForEach(content.levels.viewableTuples(of: .base), id: \.0) { label, value in
                    HStack {
                        if showLabels {
                            Text(label)
                              .font(.tableLine)
                              .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(String(format: "%.2f", value))
                          .font(.tableLine)
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
    private let rowLabels = ["prognosis", "suggestion", "singular"]
    public init() {}

    public var body: some View {
        SelectableColumn(isSelected: false) {
            VStack(spacing: 0) {
                Text("")
                    .font(.subheadline).bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 39)

                Divider()

                ForEach(Array(rates.enumerated()), id: \.0) { (blockIndex, rate) in
                    ForEach(rowLabels, id: \.self) { rowLabel in
                        Text(rowLabel)
                            .font(.tableLine)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(color(for: rate))
                            .padding(.vertical, 2)
                    }

                    if blockIndex < rates.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }

    public func color(for rate: QuotaRateType) -> Color {
        rate == .price ? .primary : .secondary
    }
}
