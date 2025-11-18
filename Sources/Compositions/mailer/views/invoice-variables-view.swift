import Foundation
import SwiftUI
import Combine
import ViewComponents
import Interfaces
import Implementations
import Structures

public struct MailerAPIInvoiceVariablesView: View {
    @ObservedObject public var viewmodel: MailerAPIInvoiceVariablesViewModel

    public init(viewmodel: MailerAPIInvoiceVariablesViewModel) {
        self.viewmodel = viewmodel
    }

    public var body: some View {
        ScrollView {
            // Section("Client & Contact") {
            StandardTextField("Client Name", text: $viewmodel.invoiceVariables.client_name, placeholder: "Acme Corp")
            StandardTextField("Email",       text: $viewmodel.invoiceVariables.email,      placeholder: "you@company.com")

            // Section("Invoice Details") {
            StandardTextField("Invoice ID",      text: $viewmodel.invoiceVariables.invoice_id,   placeholder: "e.g. 12345")
            StandardTextField("Due Date",        text: $viewmodel.invoiceVariables.due_date,     placeholder: "YYYY-MM-DD")
            StandardTextField("Product Line",    text: $viewmodel.invoiceVariables.product_line, placeholder: "Service name")

            // Section("Amounts & VAT") {
            StandardTextField("Amount",         text: $viewmodel.invoiceVariables.amount,        placeholder: "e.g. 100.00")
            StandardTextField("VAT %",          text: $viewmodel.invoiceVariables.vat_percentage, placeholder: "e.g. 21")
            StandardTextField("VAT Amount",     text: $viewmodel.invoiceVariables.vat_amount,     placeholder: "e.g. 21.00")
            StandardTextField("Total",          text: $viewmodel.invoiceVariables.total,         placeholder: "e.g. 121.00")

            // Section("Terms") {
            StandardTextField("Terms Total",   text: $viewmodel.invoiceVariables.terms_total,   placeholder: "e.g. 30 days")
            StandardTextField("Terms Current", text: $viewmodel.invoiceVariables.terms_current, placeholder: "e.g. 0 days past")

            StandardToggle(
                style: .switch,
                isOn: $viewmodel.invoiceVariables.include_invoice_document,
                title: "Include quote",
                subtitle: nil,
                width: 150
            )

        }
        .scrollContentBackground(.hidden)
    }
}
