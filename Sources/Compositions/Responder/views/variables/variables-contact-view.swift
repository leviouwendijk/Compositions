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
                StandardTextField("Client (variable: \"{{name}}\"", text: $viewmodel.client)
                    // .textFieldStyle(RoundedBorderTextFieldStyle())

                StandardTextField("Email (accepts comma-separated values)", text: $viewmodel.email)
                    // .textFieldStyle(RoundedBorderTextFieldStyle())

                if (viewmodel.anyInvalidConditionsCheck && viewmodel.emptyEmailWarning) {
                    NotificationBanner(
                        type: .info,
                        message: "No email specified"
                    )
                }
                
                StandardTextField("Dog (variable: \"{{dog}}\"", text: $viewmodel.dog)
                    // .textFieldStyle(RoundedBorderTextFieldStyle())

                StandardTextField("Location", text: Binding(
                    get: { viewmodel.local ? viewmodel.localLocation : viewmodel.location },
                    set: { viewmodel.location = $0 }
                ))
                // .textFieldStyle(RoundedBorderTextFieldStyle())

                StandardTextField("Area Code", text: Binding(
                    get: { viewmodel.local ? "" : (viewmodel.areaCode ?? "") },
                    set: { viewmodel.areaCode = viewmodel.local ? nil : ($0.isEmpty ? nil : $0) }
                ))
                // .textFieldStyle(RoundedBorderTextFieldStyle())

                StandardTextField("Street", text: Binding(
                    get: { viewmodel.local ? viewmodel.localStreet : (viewmodel.street ?? "") },
                    set: { viewmodel.street = viewmodel.local ? nil : ($0.isEmpty ? nil : $0) }
                ))
                // .textFieldStyle(RoundedBorderTextFieldStyle())

                StandardTextField("Number", text: Binding(
                    get: { viewmodel.local ? "" : (viewmodel.number ?? "") },
                    set: { viewmodel.number = viewmodel.local ? nil : ($0.isEmpty ? nil : $0) }
                ))
                // .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
