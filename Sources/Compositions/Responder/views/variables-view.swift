import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Implementations

public struct VariablesView: View, @preconcurrency Equatable {
    @ObservedObject public var contactsVm: ContactsListViewModel
    @ObservedObject public var apiPathVm: MailerAPISelectionViewModel
    @ObservedObject public var invoiceVm: MailerAPIInvoiceVariablesViewModel

    @StateObject public var waMessageNotifier: NotificationBannerController = NotificationBannerController()

    @Binding public var local: Bool
    @Binding public var selectedContact: CNContact?
    @Binding public var client: String
    @Binding public var dog: String
    @Binding public var email: String
    @Binding public var location: String
    @Binding public var areaCode: String?
    @Binding public var street: String?
    @Binding public var number: String?
    @Binding public var localLocation: String

    @Binding public var fetchableCategory: String
    @Binding public var fetchableFile: String

    @Binding public var subject: String
    @Binding public var fetchedHtml: String

    @Binding public var selectedWAMessage: WAMessageTemplate

    public let anyInvalidConditionsCheck: Bool
    public let emptyEmailWarning: Bool
    public let emptySubjectWarning: Bool
    public let finalHtmlContainsRawVariables: Bool
    public let selectedWAMessageReplaced: String
    public let waMessageContainsRawPlaceholders: Bool

    public let sendMailerEmail: () throws -> Void
    public let clearContact: () -> Void

    public static func == (lhs: VariablesView, rhs: VariablesView) -> Bool {
        return lhs.local                                       == rhs.local &&
               lhs.selectedContact == rhs.selectedContact       &&
               lhs.client                                      == rhs.client &&
               lhs.dog                                         == rhs.dog &&
               lhs.email                                       == rhs.email &&
               lhs.location                                    == rhs.location &&
               lhs.areaCode                                    == rhs.areaCode &&
               lhs.street                                      == rhs.street &&
               lhs.number                                      == rhs.number &&
               lhs.localLocation                               == rhs.localLocation &&
               lhs.fetchableCategory                           == rhs.fetchableCategory &&
               lhs.fetchableFile                               == rhs.fetchableFile &&
               lhs.subject                                     == rhs.subject &&
               lhs.fetchedHtml                                 == rhs.fetchedHtml &&
               lhs.selectedWAMessage                           == rhs.selectedWAMessage &&
               lhs.anyInvalidConditionsCheck                   == rhs.anyInvalidConditionsCheck &&
               lhs.emptyEmailWarning                           == rhs.emptyEmailWarning &&
               lhs.emptySubjectWarning                         == rhs.emptySubjectWarning &&
               lhs.finalHtmlContainsRawVariables               == rhs.finalHtmlContainsRawVariables &&
               lhs.selectedWAMessageReplaced                   == rhs.selectedWAMessageReplaced &&
               lhs.waMessageContainsRawPlaceholders            == rhs.waMessageContainsRawPlaceholders
    }

    public var body: some View {
        VStack {
            VStack {
                if !(apiPathVm.selectedRoute == .template || apiPathVm.selectedRoute == .invoice) {
                    HStack {

                        Spacer()

                        StandardToggle(
                            style: .switch,
                            isOn: $local,
                            title: "Local Location",
                            subtitle: nil
                        )
                    }
                }
            }
            .frame(maxWidth: 350)

            Divider()

            VStack(alignment: .leading) {
                if !(apiPathVm.selectedRoute == .template || apiPathVm.selectedRoute == .invoice) {
                    ContactsListView(
                        viewModel: contactsVm,
                        maxListHeight: 200,
                        onSelect: { contact in
                            clearContact()
                            selectedContact = contact
                            let split = try splitClientDog(from: contact.givenName)
                            client = split.name
                            dog    = split.dog
                            email  = contact.emailAddresses.first?.value as String? ?? ""
                            if let addr = contact.postalAddresses.first?.value {
                                location = addr.city
                                street   = addr.street
                                areaCode = addr.postalCode
                            }

                            // extra clearance logic, wa related:
                            if !selectedWAMessageReplaced.containsRawTemplatePlaceholderSyntaxes() {
                                // showWAMessageNotification = false
                                waMessageNotifier.show = false
                            }

                        },
                        onDeselect: {
                            clearContact()
                        }
                    )
                    .frame(maxWidth: 350)
                }

                Text("Mailer Arguments").bold()
                
                if apiPathVm.selectedRoute == .template {
                    HStack {
                        TextField("route", text: $fetchableCategory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("/")

                        TextField("endpoint", text: $fetchableFile)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                do {
                                    try sendMailerEmail()
                                } catch {
                                    print(error)
                                }
                            }
                    }
                } else if apiPathVm.selectedRoute == .invoice {

                    VStack {
                        HStack {
                            ThrowingEscapableButton(
                                type: .load,
                                title: "Get data",
                                action: invoiceVm.getCurrentInvoiceRender
                            )
                            
                            ThrowingEscapableButton(
                                type: .load,
                                title: "Render invoice",
                                action: invoiceVm.renderDataFromInvoiceId
                            )

                        }

                        MailerAPIInvoiceVariablesView(viewModel: invoiceVm)
                    }
                } else {
                    TextField("Client (variable: \"{{name}}\"", text: $client)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Email (accepts comma-separated values)", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if (anyInvalidConditionsCheck && emptyEmailWarning) {
                        NotificationBanner(
                            type: .info,
                            message: "No email specified"
                        )
                    }
                    
                    TextField("Dog (variable: \"{{dog}}\"", text: $dog)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Location", text: Binding(
                        get: { local ? localLocation : location },
                        set: { location = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Area Code", text: Binding(
                        get: { local ? "" : (areaCode ?? "") },
                        set: { areaCode = local ? nil : ($0.isEmpty ? nil : $0) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Street", text: Binding(
                        get: { local ? "" : (street ?? "") },
                        set: { street = local ? nil : ($0.isEmpty ? nil : $0) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Number", text: Binding(
                        get: { local ? "" : (number ?? "") },
                        set: { number = local ? nil : ($0.isEmpty ? nil : $0) }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    VStack {
                        HStack {
                            StandardButton(
                                type: .clear, 
                                title: "Clear contact", 
                                subtitle: "clears contact fields"
                            ) {
                                clearContact()
                            }

                            Spacer()
                        }
                        .frame(maxWidth: 350)

                        VStack {
                            // SectionTitle(title: "WhatsApp Message")
                            Divider()

                            HStack {
                                WAMessageDropdown(selected: $selectedWAMessage)

                                StandardButton(
                                    type: .execute, 
                                    title: "WA message", 
                                    subtitle: ""
                                ) {
                                    if !waMessageContainsRawPlaceholders {
                                        withAnimation {
                                            waMessageNotifier.show = false
                                        }

                                        selectedWAMessageReplaced
                                            .clipboard()

                                        waMessageNotifier.message = "WA message copied"
                                        waMessageNotifier.style = .success
                                        withAnimation {
                                            waMessageNotifier.show = true
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation { 
                                                waMessageNotifier.show = false
                                            }
                                        }
                                    } else {
                                        waMessageNotifier.style = .error
                                        waMessageNotifier.message = "WA message contains raw placeholders"
                                        withAnimation {
                                            waMessageNotifier.show = true
                                        }
                                    }
                                }
                                .disabled(selectedWAMessageReplaced.containsRawTemplatePlaceholderSyntaxes())

                                Spacer()
                            }
                            .frame(maxWidth: 350)

                            NotificationBanner(
                                type: waMessageNotifier.style,
                                message: waMessageNotifier.message
                            )
                            .zIndex(2)
                            .hide(when: waMessageNotifier.hide)
                        }
                    }
                }
            }
            .frame(minHeight: 600)
            .padding()
        }
        .frame(width: 400)
    }
}
