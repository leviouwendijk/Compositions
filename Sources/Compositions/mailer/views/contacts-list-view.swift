import Foundation
import SwiftUI
import Contacts
import ViewComponents
import Interfaces
import Implementations
import Structures

public struct ContactsListView: View {
    @ObservedObject public var viewmodel: ContactsListViewModel
    public let maxListHeight: CGFloat
    public let onSelect: (CNContact) throws -> Void
    public let onDeselect: () -> Void
    public let autoScrollToTop: Bool

    public init(
        viewmodel: ContactsListViewModel,
        maxListHeight: CGFloat = 200,
        onSelect: @escaping (CNContact) throws -> Void,
        onDeselect: @escaping () -> Void = {},
        autoScrollToTop: Bool = true
    ) {
        self.viewmodel = viewmodel
        self.maxListHeight = maxListHeight
        self.onSelect = onSelect
        self.onDeselect = onDeselect
        self.autoScrollToTop = autoScrollToTop
    }

    @State private var showWarning: Bool = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FuzzySearchField(
                title: "Search contacts",
                searchQuery: $viewmodel.searchQuery,
                searchStrictness:  $viewmodel.searchStrictness
            )

            if let msg = viewmodel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(msg)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(6)
                .padding(.horizontal)
            }

            if viewmodel.isLoading {
                HStack {
                    Spacer()
                    ProgressView("Loading…")
                    Spacer()
                }
                .padding()
            } else {
                contactsList()
            }
        }
    }

    @ViewBuilder
    public func contactsList() -> some View {
        ZStack {
            VStack {
                ScrollViewReader { proxy in
                    List(viewmodel.filteredContacts, id: \.identifier) { contact in
                        let isSelected = (viewmodel.selectedContactId == contact.identifier)

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if viewmodel.selectedContactId == contact.identifier {
                                    viewmodel.selectedContactId = nil
                                    onDeselect()
                                    withAnimation {
                                        showWarning = false
                                    }
                                } else {
                                    viewmodel.selectedContactId = contact.identifier

                                    if showWarning {
                                        withAnimation {
                                            showWarning = false
                                        }
                                    }

                                    do {
                                        try onSelect(contact)
                                    } catch {
                                        print("onSelect action error:", error)

                                        withAnimation {
                                            showWarning = true
                                        }
                                        
                                        // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        //     withAnimation { 
                                        //         showWarning = false 
                                        //     }
                                        // }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    let tokens = viewmodel.searchQuery.clientDogTokens
                                    let fullName = "\(contact.givenName) \(contact.familyName)"
                                    Text(fullName.highlighted(tokens))
                                    
                                    if let email = (contact.emailAddresses.first?.value as String?) {
                                        Text(email.highlighted(tokens))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()
                            }
                            // .padding(.vertical, 4)

                            .frame(maxWidth: .infinity, alignment: .leading)

                            .padding(12)
                            .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .animation(.easeInOut(duration: 0.2), value: isSelected)
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: maxListHeight)
                    .padding(.horizontal)

                    // REPLACED BY CONCURRENCY IMPLEMENATION
                    // .onChange(of: viewmodel.searchQuery) { _ in
                    //     guard autoScrollToTop,
                    //         let firstID = viewmodel.filteredContacts.first?.identifier
                    //     else { 
                    //         return
                    //     }

                    //     DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    //         withAnimation(.linear(duration: 0.05)) {
                    //             proxy.scrollTo(firstID, anchor: .top)
                    //         }
                    //     }
                    // }

                    // CONCURRENCY IMPLEMENTATION
                    .onReceive(viewmodel.$scrollToFirstID.compactMap { $0 }) { firstID in
                        guard autoScrollToTop else { return }
                        // Defer until after the table’s update pass
                        DispatchQueue.main.async {
                            withAnimation(.linear(duration: 0.05)) {
                                proxy.scrollTo(firstID, anchor: .top)
                            }
                        }
                    }
                }

                if showWarning {
                    NotificationBanner(
                        type: .warning,
                        message: "Cannot extract client and dog names"
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                }
            }
            .opacity(viewmodel.isFuzzyFiltering ? 0 : 1)

            // .overlay(
            //     Group {
            //         if viewmodel.isFuzzyFiltering {
            //             Color(NSColor.windowBackgroundColor)
            //             .opacity(0.9)
            //             .cornerRadius(6)
            //         }
            //     }
            // )

            .overlay(
                Group {
                    if !(viewmodel.searchQuery.isEmpty) && viewmodel.isFuzzyFiltering {
                        Text("“\(viewmodel.searchQuery)”…")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                        .padding(.horizontal)
                        // .background(
                        //     RoundedRectangle(cornerRadius: 6)
                        //     .fill(Color(NSColor.windowBackgroundColor))
                        // )
                        .zIndex(1)
                    } else if !(viewmodel.searchQuery.isEmpty) && !(viewmodel.isFuzzyFiltering) && viewmodel.filteredContacts.isEmpty {
                        VStack {
                            HStack {
                                Text("No results for")
                                .font(.title2)
                                .foregroundColor(Color.secondary)
                                .padding(.vertical, 6)
                                // .padding(.horizontal)
                                // .padding(.leading)

                                Text("“\(viewmodel.searchQuery)”")
                                .font(.title2)
                                .foregroundColor(Color.secondary)
                                .padding(.vertical, 6)
                                // .padding(.horizontal)
                                // .padding(.trailing)
                                // .background(
                                //     RoundedRectangle(cornerRadius: 6)
                                //     .fill(Color(NSColor.windowBackgroundColor))
                                // )
                            }
                            .padding(.horizontal)

                            Text("Adjust your query or loosen the strictness level")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                        }
                    }
                }
            )
        }
        .animation(.easeInOut(duration: 0.35), value: viewmodel.isFuzzyFiltering)
    }
}
