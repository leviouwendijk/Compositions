import Foundation
import SwiftUI
import plate
import Interfaces
import ViewComponents
import Contacts
import Implementations
import Structures

public struct VariablesContactView: View {
    @EnvironmentObject var viewmodel: ResponderViewModel

    public init() {}

    // @ObservedObject public var viewmodel: ResponderViewModel
    
    @StateObject public var waMessageNotifier: NotificationBannerController = NotificationBannerController()
    
    // public init(
    //     viewmodel: ResponderViewModel
    // ) {
    //     self.viewmodel = viewmodel
    // }

    public var body: some View {
        ScrollView {
            VStack {
                StandardTextField(
                    "Client",
                    text: $viewmodel.client,
                    placeholder: "John",
                )

                StandardTextField(
                    "Email (accepts comma-separated values)",
                    text: $viewmodel.email,
                    placeholder: "john_and_bella@yahoo.com"
                )

                if (viewmodel.anyInvalidConditionsCheck && viewmodel.emptyEmailWarning) {
                    NotificationBanner(
                        type: .info,
                        message: "No email specified"
                    )
                }
                
                StandardTextField(
                    "Dog",
                    text: $viewmodel.dog,
                    placeholder: "Bella",
                )

                if viewmodel.apiPathVm.selectedRoute == .appointment && viewmodel.apiPathVm.selectedEndpoint == .availabilityRequest {
                    StandardTextField(
                        "Sessions",
                        text: $viewmodel.sessionCount,
                        placeholder: "1, 3, 4 schedulable sessions",
                    )
                }

                if viewmodel.selectedWAMessage == .contract {
                    StandardTextField(
                        "Deliverable",
                        text: $viewmodel.deliverable,
                        placeholder: "Geadviseerde sessie-aantal, Puppy-pakket",
                    )

                    StandardTextField(
                        "Session Count",
                        text: $viewmodel.sessions,
                        placeholder: "3, 5, 7",
                    )

                    VStack {
                        Text("Duration")
                        HStack {
                            StandardTextField(
                                "from",
                                text: $viewmodel.fromMinutes,
                                placeholder: "60",
                            )

                            StandardTextField(
                                "to",
                                text: $viewmodel.toMinutes,
                                placeholder: "120",
                            )
                        }
                    }

                    StandardTextField(
                        "Price",
                        text: $viewmodel.price,
                        placeholder: "1245",
                    )
                }

                StandardTextField(
                    "Location",
                    text: Binding(
                        get: { viewmodel.local ? viewmodel.localLocation : viewmodel.location },
                        set: { viewmodel.location = $0 }
                    ),
                    placeholder: "Amsterdam"
                )

                StandardTextField(
                    "Area Code", 
                    text: Binding(
                        get: { viewmodel.local ? "" : (viewmodel.areaCode ?? "") },
                        set: { viewmodel.areaCode = viewmodel.local ? nil : ($0.isEmpty ? nil : $0) }
                    ),
                    placeholder: "1234 AB"
                )

                StandardTextField(
                    "Street",
                    text: Binding(
                        get: { viewmodel.local ? viewmodel.localStreet : (viewmodel.street ?? "") },
                        set: { viewmodel.street = viewmodel.local ? nil : ($0.isEmpty ? nil : $0) }
                    ),
                    placeholder: "Langestraat"
                )

                StandardTextField(
                    "Number",
                    text: Binding(
                        get: { viewmodel.local ? "" : (viewmodel.number ?? "") },
                        set: { viewmodel.number = viewmodel.local ? nil : ($0.isEmpty ? nil : $0) }
                    ),
                    placeholder: "51"
                )
            }
        }
    }
}
