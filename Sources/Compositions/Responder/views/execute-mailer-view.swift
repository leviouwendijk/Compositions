import Foundation
import SwiftUI
import ViewComponents

public struct ExecuteMailerView: View, @preconcurrency Equatable {
    @Binding public var isSendingEmail: Bool
    @Binding public var showSuccessBanner: Bool
    @Binding public var successBannerMessage: String
    @Binding public var bannerColor: Color

    public let sendMailerEmail: () throws -> Void

    public init(
        isSendingEmail: Binding<Bool>,
        showSuccessBanner: Binding<Bool>,
        successBannerMessage: Binding<String>,
        bannerColor: Binding<Color>,
        sendMailerEmail: @escaping () throws -> Void
    ) {
        self._isSendingEmail = isSendingEmail
        self._showSuccessBanner = showSuccessBanner
        self._successBannerMessage = successBannerMessage
        self._bannerColor = bannerColor
        self.sendMailerEmail = sendMailerEmail
    }

    public static func == (lhs: ExecuteMailerView, rhs: ExecuteMailerView) -> Bool {
        return
            lhs.isSendingEmail == rhs.isSendingEmail &&
            lhs.showSuccessBanner == rhs.showSuccessBanner &&
            lhs.successBannerMessage == rhs.successBannerMessage &&
            lhs.bannerColor == rhs.bannerColor
    }

    public var body: some View {
        VStack {
            if showSuccessBanner {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: bannerColor == .green
                                ? "checkmark.circle.fill"
                                : "xmark.octagon.fill"
                        )
                        .foregroundColor(.white)
                        Text(successBannerMessage)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(bannerColor)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: showSuccessBanner)
            }
            else {
                if isSendingEmail {
                    HStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Sending...")
                    }
                    .padding(.bottom, 10)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isSendingEmail)
                }

                HStack {
                    StandardEscapableButton(
                        type: .execute,
                        title: "Run mailer",
                        cancelTitle: "Do not run mailer yet",
                        subtitle: "Starts mailer background process"
                    ) {
                        do {
                            try sendMailerEmail()
                        } catch {
                            print(error)
                        }
                    }
                    .disabled(isSendingEmail)
                }
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
