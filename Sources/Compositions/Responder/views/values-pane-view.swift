import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Economics
import Implementations

public struct ValuesPaneView: View, @preconcurrency Equatable {
    // observables (passed)
    @ObservedObject public var apiPathVm: MailerAPISelectionViewModel
    @ObservedObject public var weeklyScheduleVm: WeeklyScheduleViewModel
    @ObservedObject public var quotaVm: QuotaViewModel

    // // local state object inits
    // @StateObject public var localPdfNotifier: NotificationBannerController = NotificationBannerController()
    // @StateObject public var combinedPdfNotifier: NotificationBannerController = NotificationBannerController()
    // @StateObject public var remotePdfNotifier: NotificationBannerController = NotificationBannerController()

    // passed properties
    @Binding public var subject: String
    @Binding public var fetchedHtml: String
    @Binding public var includeQuoteInCustomMessage: Bool

    public let anyInvalidConditionsCheck: Bool
    public let emptySubjectWarning: Bool
    public let finalHtmlContainsRawVariables: Bool

    public let clientIdentifier: String

    public let sendMailerEmail: () throws -> Void

    public init(
        apiPathVm: MailerAPISelectionViewModel,
        weeklyScheduleVm: WeeklyScheduleViewModel,
        quotaVm: QuotaViewModel,
        subject: Binding<String>,
        fetchedHtml: Binding<String>,
        includeQuoteInCustomMessage: Binding<Bool>,
        anyInvalidConditionsCheck: Bool,
        emptySubjectWarning: Bool,
        finalHtmlContainsRawVariables: Bool,
        clientIdentifier: String,
        sendMailerEmail: @escaping () throws -> Void
    ) {
        self.apiPathVm = apiPathVm
        self.weeklyScheduleVm = weeklyScheduleVm
        self.quotaVm = quotaVm

        self._subject = subject
        self._fetchedHtml = fetchedHtml
        self._includeQuoteInCustomMessage = includeQuoteInCustomMessage

        self.anyInvalidConditionsCheck = anyInvalidConditionsCheck
        self.emptySubjectWarning = emptySubjectWarning
        self.finalHtmlContainsRawVariables = finalHtmlContainsRawVariables

        self.clientIdentifier = clientIdentifier

        self.sendMailerEmail = sendMailerEmail
    }

    public static func == (lhs: ValuesPaneView, rhs: ValuesPaneView) -> Bool {
        return lhs.subject                     == rhs.subject &&
               lhs.fetchedHtml                 == rhs.fetchedHtml &&
               lhs.includeQuoteInCustomMessage == rhs.includeQuoteInCustomMessage &&
               lhs.anyInvalidConditionsCheck   == rhs.anyInvalidConditionsCheck &&
               lhs.emptySubjectWarning         == rhs.emptySubjectWarning &&
               lhs.finalHtmlContainsRawVariables == rhs.finalHtmlContainsRawVariables &&
               lhs.clientIdentifier            == rhs.clientIdentifier
    }

    public var body: some View {
        VStack {
            if apiPathVm.selectedRoute == .custom {
                VStack(alignment: .leading) {

                    TextField("Subject", text: $subject)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if (anyInvalidConditionsCheck && emptySubjectWarning) {
                        NotificationBanner(
                            type: .info,
                            message: "Empty subject"
                        )
                    }

                    Text("Template HTML").bold()

                    CodeEditorContainer(text: $fetchedHtml)

                    if (anyInvalidConditionsCheck && finalHtmlContainsRawVariables) {
                        NotificationBanner(
                            type: .warning,
                            message: "Raw html variables still in your message"
                        )
                    }

                    HStack {
                        StandardButton(
                            type: .clear, 
                            title: "Clear HTML", 
                            subtitle: "clears fetched html"
                        ) {
                            fetchedHtml = ""
                        }

                        Spacer()

                        if apiPathVm.selectedRoute == .custom {
                            StandardToggle(
                                style: .switch,
                                isOn: $includeQuoteInCustomMessage,
                                title: "Include quote",
                                subtitle: nil,
                                width: 150
                            )
                        }
                    }
                    .padding()
                }
                .padding()
            } else if apiPathVm.selectedRoute == .quote {
                VStack(alignment: .leading, spacing: 12) {
                    // 1) “Kilometers” field
                    StandardTextField(
                        "kilometers",
                        text: Binding<String>(
                            get:  { quotaVm.customQuotaInputs.travelCost.kilometers },
                            set:  { newValue in
                                quotaVm.customQuotaInputs.travelCost.kilometers = newValue
                            }
                        ),
                        placeholder: "45"
                    )

                    // 2) Prognosis / Local
                    HStack {
                        StandardTextField(
                            "prognosis",
                            text: Binding<String>(
                                get:  { quotaVm.customQuotaInputs.prognosis.count },
                                set:  { newValue in
                                    quotaVm.customQuotaInputs.prognosis.count = newValue
                                }
                            ),
                            placeholder: "5"
                        )
                        StandardTextField(
                            "local",
                            text: Binding<String>(
                                get:  { quotaVm.customQuotaInputs.prognosis.local },
                                set:  { newValue in
                                    quotaVm.customQuotaInputs.prognosis.local = newValue
                                }
                            ),
                            placeholder: "4"
                        )
                    }

                    // 3) Suggestion / Local
                    HStack {
                        StandardTextField(
                            "suggestion",
                            text: Binding<String>(
                                get:  { quotaVm.customQuotaInputs.suggestion.count },
                                set:  { newValue in
                                    quotaVm.customQuotaInputs.suggestion.count = newValue
                                }
                            ),
                            placeholder: "3"
                        )
                        StandardTextField(
                            "local",
                            text: Binding<String>(
                                get:  { quotaVm.customQuotaInputs.suggestion.local },
                                set:  { newValue in
                                    quotaVm.customQuotaInputs.suggestion.local = newValue
                                }
                            ),
                            placeholder: "2"
                        )
                    }

                    // Singular / Local
                    HStack {
                        StandardTextField(
                            "singular",
                            text: Binding<String>(
                                get:  { quotaVm.customQuotaInputs.singular.count },
                                set:  { newValue in
                                    quotaVm.customQuotaInputs.singular.count = newValue
                                }
                            ),
                            placeholder: "1"
                        )
                        StandardTextField(
                            "local",
                            text: Binding<String>(
                                get:  { quotaVm.customQuotaInputs.singular.local },
                                set:  { newValue in
                                    quotaVm.customQuotaInputs.singular.local = newValue
                                }
                            ),
                            placeholder: "0"
                        )
                    }


                    // 4) Base
                    StandardTextField(
                        "base",
                        text: Binding<String>(
                            get:  { quotaVm.customQuotaInputs.base },
                            set:  { newValue in
                                quotaVm.customQuotaInputs.base = newValue
                            }
                        ),
                        placeholder: "350"
                    )

                    // 5) Travel‐cost fields
                    VStack(alignment: .leading, spacing: 8) {
                        // Text("Travel Cost Inputs").bold()
                        HStack {
                            StandardTextField(
                                "speed",
                                text: Binding<String>(
                                    get:  { quotaVm.customQuotaInputs.travelCost.speed },
                                    set:  { newValue in
                                        quotaVm.customQuotaInputs.travelCost.speed = newValue
                                    }
                                ),
                                placeholder: "80.0"
                            )
                            StandardTextField(
                                "rate/travel",
                                text: Binding<String>(
                                    get:  { quotaVm.customQuotaInputs.travelCost.rates.travel },
                                    set:  { newValue in
                                        quotaVm.customQuotaInputs.travelCost.rates = TravelCostRatesInputs(
                                            travel: newValue,
                                            time: quotaVm.customQuotaInputs.travelCost.rates.time
                                        )
                                    }
                                ),
                                placeholder: "0.25"
                            )
                            StandardTextField(
                                "rate/time",
                                text: Binding<String>(
                                    get:  { quotaVm.customQuotaInputs.travelCost.rates.time },
                                    set:  { newValue in
                                        quotaVm.customQuotaInputs.travelCost.rates = TravelCostRatesInputs(
                                            travel: quotaVm.customQuotaInputs.travelCost.rates.travel,
                                            time: newValue
                                        )
                                    }
                                ),
                                placeholder: "105"
                            )
                        }
                    }
                    .padding(.top, 8)

                    // 6) Decide what to show:
                    if quotaVm.isLoading {
                        ProgressView("Computing quota…")
                            .padding(.top, 16)
                    }

                    if !(quotaVm.errorMessage.isEmpty) {
                        if quotaVm.hasEmptyInputs {
                            NotificationBanner(
                                type: .info,
                                message: "Enter inputs"
                            )
                        } else {
                            NotificationBanner(
                                type: .warning,
                                message: quotaVm.errorMessage
                            )
                        }
                    }

                    else if let quota = quotaVm.loadedQuota {
                        QuotaTierListView(quota: quota)
                            .padding(.top, 12)
                            .padding(.bottom, 12)

                        QuotaTierActionsView(quota: quota, clientIdentifier: clientIdentifier)
                    }
                    else {
                        NotificationBanner(
                            type: .info,
                            message: "Enter quote values above"
                        )
                        .padding(.top, 16)
                    }
                }
                .padding()
            } else {

                if apiPathVm.endpointNeedsAvailabilityVariable {
                    VStack(alignment: .leading, spacing: 8) {
                        WeeklyScheduleView(viewModel: weeklyScheduleVm)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .frame(minWidth: 400)

        Spacer()
    }
}
