import Foundation
import SwiftUI
import ViewComponents
import Implementations

public struct ExecuteMailerView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    public init() {}

    // @ObservedObject public var viewmodel: ResponderViewModel
    
    // public init(
    //     viewmodel: ResponderViewModel
    // ) {
    //     self.viewmodel = viewmodel
    // }

    public var body: some View {
        VStack {
            if viewmodel.showSuccessBanner {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: viewmodel.bannerColor == .green
                                ? "checkmark.circle.fill"
                                : "xmark.octagon.fill"
                        )
                        .foregroundColor(.white)
                        Text(viewmodel.successBannerMessage)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(viewmodel.bannerColor)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: viewmodel.showSuccessBanner)
            }
            else {
                if viewmodel.isSendingEmail {
                    HStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Sending...")
                    }
                    .padding(.bottom, 10)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: viewmodel.isSendingEmail)
                }

                VStack {
                    NotificationBanner(
                        type: .error,
                        message: viewmodel.errorMessage
                    )
                    .hide(when: viewmodel.errorMessage.isEmpty)

                    HStack {
                        StandardEscapableButton(
                            type: .execute,
                            title: "Run mailer",
                            cancelTitle: "Do not run mailer yet",
                            subtitle: "Starts mailer background process"
                        ) {
                            do {
                                try viewmodel.sendMailerEmail()
                                // viewmodel.errorMessage = ""
                            } catch {
                                print(error)
                                // viewmodel.errorMessage = error.localizedDescription
                            }
                        }
                        .disabled(viewmodel.isSendingEmail)
                        .disabled(viewmodel.apiPathVm.routeOrEndpointIsNil)
                        .disabled(!(viewmodel.apiPathVm.selectedRoute == .invoice)) // enable for only invoicing

                        StandardEscapableButton(
                            type: .submit,
                            title: "Send",
                            cancelTitle: "Abort sending",
                            subtitle: "Direct API"
                        ) {
                            do {
                                try viewmodel.send()
                                // viewmodel.errorMessage = ""
                            } catch {
                                print(error.localizedDescription)
                                // viewmodel.errorMessage = error.localizedDescription
                            }
                        }
                        .disabled(viewmodel.isSendingEmail)
                        .disabled(viewmodel.apiPathVm.routeOrEndpointIsNil)
                        // .disabled(viewmodel.apiPathVm.selectedRoute == .invoice) // disable until db invoicing
                    }
                    .padding(.top, 10)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
