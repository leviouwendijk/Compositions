import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Implementations
import Structures

public struct VariablesView: View {
    @ObservedObject public var viewmodel: ResponderViewModel
    @StateObject public var waMessageNotifier: NotificationBannerController = NotificationBannerController()
    
    public init(
        viewmodel: ResponderViewModel
    ) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        VStack {
            VStack {
                if !(viewmodel.apiPathVm.selectedRoute == .template || viewmodel.apiPathVm.selectedRoute == .invoice) {
                    HStack {

                        Spacer()

                        StandardToggle(
                            style: .switch,
                            isOn: $viewmodel.local,
                            title: "Local Location",
                            subtitle: nil
                        )
                    }
                }
            }
            .frame(maxWidth: 350)

            Divider()

            VStack(alignment: .leading) {
                if !(viewmodel.apiPathVm.selectedRoute == .template || viewmodel.apiPathVm.selectedRoute == .invoice) {
                    ContactsListView(
                        viewModel: viewmodel.contactsVm,
                        maxListHeight: 200,
                        onSelect: { contact in
                            viewmodel.clearContact()
                            viewmodel.selectedContact = contact
                            let split = try splitClientDog(from: contact.givenName)
                            viewmodel.client = split.name
                            viewmodel.dog    = split.dog
                            viewmodel.email  = contact.emailAddresses.first?.value as String? ?? ""
                            if let addr = contact.postalAddresses.first?.value {
                                viewmodel.location = addr.city
                                viewmodel.street   = addr.street
                                viewmodel.areaCode = addr.postalCode
                            }

                            // extra clearance logic, wa related:
                            if !viewmodel.selectedWAMessageReplaced.containsRawTemplatePlaceholderSyntaxes() {
                                // showWAMessageNotification = false
                                waMessageNotifier.show = false
                            }

                        },
                        onDeselect: {
                            viewmodel.clearContact()
                        }
                    )
                    .frame(maxWidth: 350)
                }

                Text("Mailer Arguments").bold()
                
                if viewmodel.apiPathVm.selectedRoute == .template {
                    HStack {
                        StandardTextField("route", text: $viewmodel.fetchableCategory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("/")

                        StandardTextField("endpoint", text: $viewmodel.fetchableFile)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                do {
                                    try viewmodel.sendMailerEmail()
                                } catch {
                                    print(error)
                                }
                            }
                    }
                } else if viewmodel.apiPathVm.selectedRoute == .invoice {
                    VStack {
                        HStack {
                            ThrowingEscapableButton(
                                type: .load,
                                title: "Get data",
                                action: viewmodel.invoiceVm.getCurrentInvoiceRender
                            )
                            
                            ThrowingEscapableButton(
                                type: .load,
                                title: "Render invoice",
                                action: viewmodel.invoiceVm.renderDataFromInvoiceId
                            )

                        }

                        MailerAPIInvoiceVariablesView(viewModel: viewmodel.invoiceVm)
                    }
                } else {
                    VariablesContactView(viewmodel: viewmodel)

                    VStack {
                        HStack {
                            StandardButton(
                                type: .clear, 
                                title: "Clear contact", 
                                subtitle: "clears contact fields"
                            ) {
                                viewmodel.clearContact()
                            }

                            Spacer()
                        }
                        .frame(maxWidth: 350)

                        VariablesWAMessageView(viewmodel: viewmodel, notifier: waMessageNotifier)
                    }
                }
            }
            .frame(minHeight: 600)
            .padding()
        }
        .frame(width: 400)
    }
}
