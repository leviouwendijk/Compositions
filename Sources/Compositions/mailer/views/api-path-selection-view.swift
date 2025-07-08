import SwiftUI
import ViewComponents
import Interfaces
import Implementations
import Structures

public struct MailerAPIPathSelectionView: View {
    @ObservedObject public var viewModel: MailerAPISelectionViewModel

    public init(viewModel: MailerAPISelectionViewModel) {
        self.viewModel = viewModel
    }

    private var disabledFileSelected: Bool {
        // e.g. show banner when there’s no valid endpoint chosen
        viewModel.selectedEndpoint == nil
    }

    public var body: some View {
        VStack {
            VStack {
                HStack {
                    // ─── ROUTES COLUMN ─────────────────────────────
                    VStack {
                        SectionTitle(title: "Route", width: 150, fontSize: 14)

                        ScrollView {
                            VStack(spacing: 5) {
                                ForEach(MailerAPIRoute.allCases, id: \.self) { route in
                                    SelectableRow(
                                        // title: route.rawValue.capitalized,
                                        title: route.viewableString(),
                                        isSelected: viewModel.selectedRoute == route,
                                        animationDuration: 0.3
                                    ) {
                                        if viewModel.selectedRoute == route {
                                            viewModel.selectedRoute = nil
                                        } else {
                                            viewModel.selectedRoute = route
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .frame(width: 160)

                    // ─── ENDPOINTS COLUMN ───────────────────────────
                    VStack {
                        SectionTitle(title: "Endpoint", width: 150, fontSize: 14)

                        ScrollView {
                            VStack(spacing: 5) {
                                // ForEach(viewModel.validEndpoints.filter { $0.isFrontEndVisible }, id: \.self) { endpoint in
                                ForEach(viewModel.validEndpoints, id: \.self) { endpoint in
                                    SelectableRow(
                                        // title: endpoint.rawValue.capitalized,
                                        title: endpoint.viewableString(),
                                        isSelected: viewModel.selectedEndpoint == endpoint
                                    ) {
                                        if viewModel.selectedEndpoint == endpoint {
                                            viewModel.selectedEndpoint = nil
                                        } else {
                                            viewModel.selectedEndpoint = endpoint
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .disabled(!(endpoint.isFrontEndVisible))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .frame(width: 160)
                }
            }

            if !(viewModel.viewableURL().viewableURLString().isEmpty) {
                SectionTitle(title: viewModel.viewableURL().viewableURLString(), width: 400, fontSize: 10)
            }

            if disabledFileSelected {
                NotificationBanner(
                    type: .info,
                    message: "No endpoint selected"
                )
            }
        }
    }
}
