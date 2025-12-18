import SwiftUI
import plate
import Interfaces
import Structures
import ViewComponents
import Implementations
import Version

@MainActor
public struct BuildInformationSwitch: View {
    @StateObject public var viewmodel: BuildInformationViewModel

    public init(
        viewmodel: BuildInformationViewModel? = nil,

        alignment: AlignmentStyle = .center,
        display: [[BuildInformationDisplayComponents]] = [[.version], [.latestVersion], [.name], [.author]],
        prefixStyle: VersionPrefixStyle = .long
    ) {
        let vm = viewmodel ?? BuildInformationViewModel(
            alignment: alignment,
            display: display,
            prefixStyle: prefixStyle
        )
        _viewmodel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                viewmodel.current = (viewmodel.current + 1) % viewmodel.display.count
            }
        }) {
            ZStack {
                HStack {
                    if viewmodel.alignment == .trailing { Spacer() }
                    VStack {
                        if viewmodel.display[viewmodel.current].contains(.name) {
                            Text(viewmodel.build_object?.name ?? "")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }

                        if viewmodel.display[viewmodel.current].contains(.version) {
                            VStack {
                                if !(viewmodel.updateError.isEmpty) {
                                    NotificationBanner(
                                        type: .error,
                                        message: viewmodel.updateError
                                    )
                                }

                                let banner = viewmodel.primaryBannerText()

                                HStack {
                                    Text(viewmodel.localVersionString())
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .strikethrough(banner != nil)

                                    if let banner = banner {
                                        Text(banner)
                                            .font(.footnote)
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                        }

                        if viewmodel.display[viewmodel.current].contains(.latestVersion) {
                            VStack {
                                if !(viewmodel.updateError.isEmpty) {
                                    NotificationBanner(
                                        type: .error,
                                        message: viewmodel.updateError
                                    )
                                }

                                HStack {
                                    Text(viewmodel.remoteVersionString())
                                        .font(.footnote)
                                        .foregroundColor(.secondary)

                                    if viewmodel.primaryBannerText() != nil, viewmodel.isUpdateAvailable {
                                        Text("update available")
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                    }
                                }
                            }
                        }

                        if viewmodel.display[viewmodel.current].contains(.author) {
                            Text(viewmodel.build_object?.author ?? "")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }
                    }
                    if viewmodel.alignment == .leading { Spacer() }
                }
                .id(viewmodel.current)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal:   .move(edge: .top).combined(with: .opacity)
                ))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(NSColor.windowBackgroundColor).opacity(0.1))
        }
        .buttonStyle(.plain)
        .task {
            await viewmodel.refresh()
        }
    }
}
