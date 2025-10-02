import SwiftUI
import plate
import Interfaces
import Economics
import ViewComponents
import Implementations

public struct QuotaView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    @StateObject public var quotaVm: QuotaViewModel

    public init(
        quotaVm: QuotaViewModel = QuotaViewModel()
    ) {
        _quotaVm = StateObject(wrappedValue: quotaVm)
    }

    // public init() {}
    // @ObservedObject public var viewmodel: ResponderViewModel

    // public init(
    //     viewmodel: ResponderViewModel
    // ) {
    //     self.viewmodel = viewmodel
    // }

    public var body: some View {
        VStack {
            VStack {
                HStack {
                    ScrollView {
                        QuotaInputsView(viewmodel: quotaVm)
                        .frame(maxWidth: 300)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .frame(height: .infinity)
                    }

                    Spacer()

                    ScrollView {
                        QuotaTableView(viewmodel: quotaVm)
                        .frame(height: .infinity)
                    }
                }

                // HStack {
                //     ContactsListView(
                //         viewmodel: viewmodel.contactsVm,
                //         maxListHeight: 300,
                //         onSelect: { contact in
                //             viewmodel.clearContact()
                //             viewmodel.selectedContact = contact
                //             let split = try splitClientDog(from: contact.givenName)
                //             viewmodel.client = split.name
                //             viewmodel.dog    = split.dog
                //             viewmodel.email  = contact.emailAddresses.first?.value as String? ?? ""
                //             if let addr = contact.postalAddresses.first?.value {
                //                 viewmodel.location = addr.city
                //                 viewmodel.street   = addr.street
                //                 viewmodel.areaCode = addr.postalCode
                //             }
                //         },
                //         onDeselect: {
                //             viewmodel.clearContact()
                //         }
                //     )
                //     .frame(maxWidth: 400)
                //     .frame(maxHeight: .infinity)

                //     Spacer()
                // }
                // .padding(.top, 24)

            }
            // .frame(minHeight: 420)
            // .frame(height: 420)
            // attempt without forcing any height? -- leave to window

            Spacer()

            QuotaStatusView(
                viewmodel: quotaVm
            )

            // if let quota = quotaVm.loadedQuota {
                QuotaTierActionsView(
                    viewmodel: quotaVm, 
                    // quota: quota,
                    clientIdentifier: viewmodel.clientIdentifier
                )
            // }
        }
    }
}
