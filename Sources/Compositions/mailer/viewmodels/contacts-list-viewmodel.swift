import SwiftUI
@preconcurrency import Contacts
import Combine
import Interfaces
import plate
import ViewComponents

@MainActor
public class ContactsListViewModel: ObservableObject {
    // @Published public var contacts: [CNContact] = []
    // @Published public var searchQuery: String = ""
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    // @Published public var searchStrictness: SearchStrictness = .strict


    /// When these change, we’ll “debounce” and then re‐filter.
    @Published public var contacts: [CNContact] = [] {
        didSet { scheduleFilterIfNeeded() }
    }
    @Published public var searchQuery: String = "" {
        didSet { scheduleFilterIfNeeded() }
    }
    @Published public var searchStrictness: SearchStrictness = .strict {
        didSet { scheduleFilterIfNeeded() }
    }

    // @Published public private(set) var filteredContacts: [CNContact] = []
    @Published public private(set) var filteredContacts: [CNContact] = [] {
        didSet {
            // Run “after filter is done” logic here, exactly once per new array:
            withAnimation(.easeInOut(duration: 0.20)) {
                isFuzzyFiltering = false
            }
            scrollToFirstID = filteredContacts.first?.identifier
        }
    }

    @Published public var isFuzzyFiltering = false

    @Published public var selectedContactId: String? = nil
    @Published public var scrollToFirstID: String? = nil

    /// A DispatchWorkItem that we cancel+reschedule whenever any input changes.
    private var pendingFilterWorkItem: DispatchWorkItem?

    /// How long to wait after the “last change” before actually filtering.
    private let debounceInterval: TimeInterval = 0.2

    public init() {
        Task { 
            await loadAllContacts()
        }
        // fuzzyFilterListener()
    }

    public func loadAllContacts() async {
        // DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        // }
        do {
            let fetched = try await loadContacts()
            // DispatchQueue.main.async {
                print("[ContactsVM] assigning contacts (\(fetched.count) items)")
                self.contacts = fetched
                self.isLoading = false
            // }
        } catch {
            // DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            // }
        }
        // isLoading = false
    }

    private var cancellables = Set<AnyCancellable>()

    public func fuzzyFilterListener() {
        Publishers
        .CombineLatest3($contacts, $searchQuery, $searchStrictness)
        .drop { contacts, _, _ in contacts.isEmpty }
        .removeDuplicates(by: { a, b in
            return a.0.count == b.0.count
            && a.1 == b.1
            && a.2 == b.2
        })
        .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
        .sink { [weak self] allContacts, query, strictness in
            guard let self = self else { return }

            if !(self.isLoading) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    self.isFuzzyFiltering = true
                }
            }

            self.applyFuzzyFilter(
                to: allContacts,
                query: query,
                tolerance: strictness.tolerance
            )
        }
        .store(in: &cancellables)
    }

    public func applyFuzzyFilter(
        to allContacts: [CNContact],
        query: String,
        tolerance: Int
    ) {
        let normalized = query.normalizedForClientDogSearch

        DispatchQueue.global(qos: .userInitiated).async {
            let results = allContacts
            .filteredClientContacts(
                matching: normalized,
                fuzzyTolerance: tolerance
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                withAnimation(.easeInOut(duration: 0.20)) {
                    self.filteredContacts = results
                    self.isFuzzyFiltering = false
                }
                self.scrollToFirstID = results.first?.identifier
            }
        }
    }

    public func scheduleFilterIfNeeded() {
        guard !contacts.isEmpty else {
            return
        }

        pendingFilterWorkItem?.cancel()

        // snapshot all Main-Actor‐isolated inputs before going off to a background queue:
        let snapshotContacts   = self.contacts            // [CNContact]
        let snapshotQuery      = self.searchQuery          // String
        let snapshotStrictness = self.searchStrictness     // SearchStrictness

        if !isLoading {
            withAnimation(.easeInOut(duration: 0.25)) {
                isFuzzyFiltering = true
            }
        }

        let work = DispatchWorkItem { [weak self] in
            let normalized = snapshotQuery.normalizedForClientDogSearch

            let results = snapshotContacts.filteredClientContacts(
                matching: normalized,
                fuzzyTolerance: snapshotStrictness.tolerance
            )

            // return to the Main Actor (via DispatchQueue.main) to assign `filteredContacts`:
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.filteredContacts = results
                // The `didSet` on `filteredContacts` will run next,
                // clearing `isFuzzyFiltering` and setting `scrollToFirstID`.
            }
        }

        pendingFilterWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: work)
    }
}
