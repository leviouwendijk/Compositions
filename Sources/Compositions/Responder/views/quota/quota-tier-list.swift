import Foundation
import SwiftUI
import plate
import Economics
import ViewComponents
import Implementations

public struct QuotaTierListView: View {
    @ObservedObject public var viewmodel: QuotaViewModel

    public init (
        viewmodel: QuotaViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            if let t = viewmodel.tiers {
                QuotaTierListSubView(
                    tiers: t
                )
                .frame(maxHeight: 420)
            } else {
                VStack {
                    NotificationBanner(
                        type: .warning, 
                        message: viewmodel.errorMessage
                    )
                }
            }
        }
    }
}

public struct QuotaTierListSubView: View {
    public let tiers: [QuotaTierContent]

    public init(
        tiers: [QuotaTierContent],
    ) {
        self.tiers = tiers
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // ─── HEADER ROW ──────────────────────────────────────────────────
                HStack(spacing: 0) {
                    // 1st cell is empty, to align with row labels below
                    Text("")
                        .frame(width: 80, alignment: .leading)

                    ForEach(tiers, id: \.tier) { content in
                        Text(content.tier.rawValue.capitalized)
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                VStack(spacing: 24) { // extra space between subtables, but not from header
                    // ─── PRICE BLOCK ────────────────────────────────────────────────
                    VStack(spacing: 4) {
                        // “Price” as a spanning header
                        HStack {
                            Text("Price")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }
                        .padding(.vertical, 4)

                        Divider()
                        .padding(.vertical, 4)

                        TableBlock(
                            rowLabelWidth: 80,
                            tiers: tiers,
                            valuesFor: { content in
                                content.levels.viewableTuples(of: .price)
                            },
                            textColor: .primary
                        )
                    }

                    // ─── COST BLOCK ─────────────────────────────────────────────────
                    VStack(spacing: 4) {
                        HStack {
                            Text("Cost")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }
                        .padding(.vertical, 4)

                        Divider()
                        .padding(.vertical, 4)

                        TableBlock(
                            rowLabelWidth: 80,
                            tiers: tiers,
                            valuesFor: { content in
                                content.levels.viewableTuples(of: .cost)
                            },
                            textColor: .secondary
                        )
                    }

                    // ─── BASE BLOCK ─────────────────────────────────────────────────
                    VStack(spacing: 4) {
                        HStack {
                            Text("Base")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }
                        .padding(.vertical, 4)

                        Divider()
                        .padding(.vertical, 4)

                        TableBlock(
                            rowLabelWidth: 80,
                            tiers: tiers,
                            valuesFor: { content in
                                content.levels.viewableTuples(of: .base)
                            },
                            textColor: .secondary
                        )
                    }

                    // Spacer(minLength: 0)
                }
            }
            .padding()
        }
    }
}

public struct TableBlock: View {
    public let rowLabelWidth: CGFloat
    public let tiers: [QuotaTierContent]
    public let valuesFor: (QuotaTierContent) -> [(String, Double)]
    public let textColor: Color

    public var allRows: [String]            // row names, e.g. ["prognosis", "suggestion", …]
    public var tierValueMatrix: [[Double]]  // tierValueMatrix[rowIndex][tierIndex]
    public var isPrognosisRow: [Bool]       // true if the “String” is “prognosis”

    public init(
        rowLabelWidth: CGFloat,
        tiers: [QuotaTierContent],
        valuesFor: @escaping (QuotaTierContent) -> [(String, Double)],
        textColor: Color,
    ) {
        self.rowLabelWidth = rowLabelWidth
        self.tiers = tiers
        self.valuesFor = valuesFor
        self.textColor = textColor

        let firstTuples = valuesFor(tiers.first!)
        self.allRows = firstTuples.map { $0.0 }
        self.isPrognosisRow = firstTuples.map { $0.0 == "prognosis" }

        var matrix: [[Double]] = Array(
            repeating: [Double](),
            count: firstTuples.count
        )
        for (tierIndex, tierContent) in tiers.enumerated() {
            let tuples = valuesFor(tierContent) // e.g. [("prognosis", 12.34), ("suggestion", 8.90), …]
            for rowIndex in 0 ..< tuples.count {
                let value = tuples[rowIndex].1
                if tierIndex == 0 {
                    matrix[rowIndex].append(value)
                } else {
                    matrix[rowIndex].append(value)
                }
            }
        }
        self.tierValueMatrix = matrix
    }

    public var body: some View {
        VStack(spacing: 8) {
            ForEach(allRows.indices, id: \.self) { rowIndex in
                HStack(spacing: 4) {
                let label = allRows[rowIndex]
                Text(label)
                .font(.subheadline)
                .frame(width: rowLabelWidth,
                        alignment: .leading)
                .foregroundStyle(textColor)

                    ForEach(Array(tiers.indices), id: \.self) { tierIndex in
                        let rawValue = tierValueMatrix[rowIndex][tierIndex]
                        let str      = String(format: "%.2f", rawValue)
                        let displayed = isPrognosisRow[rowIndex] ? "(\(str))" : str

                        Text(displayed)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(textColor)
                        .padding(4)
                        // .background(
                        //     (viewmodel.selectedTier == .local)
                        //       ? Color.blue.opacity(0.1)
                        //       : Color.clear
                        // )

                    }
                }
            }
        }
    }
}

public struct StatView: View {
    public let label: String
    public let value: Double

    public var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "%.2f", value))
                .font(.body)
                .bold()
        }
    }
}
