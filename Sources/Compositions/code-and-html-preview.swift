import SwiftUI
import Implementations
import ViewComponents

public struct CodeAndPreviewView: View {
    @StateObject public var viewmodel = HTMLPreviewViewModel()

    public init() {}

    public var body: some View {
        HSplitView {
            CodeEditor(text: $viewmodel.html)
                .frame(minWidth: 300)
            HTMLPreview(html: $viewmodel.html)
                .frame(minWidth: 300)
        }
        .frame(minHeight: 400)
    }
}

public struct VimCodeAndPreviewView: View {
    @StateObject public var viewmodel = HTMLPreviewViewModel()

    public init() {}

    public var body: some View {
        HSplitView {
            VimCodeEditor(text: $viewmodel.html)
                .frame(minWidth: 300)
            HTMLPreview(html: $viewmodel.html)
                .frame(minWidth: 300)
        }
        .frame(minHeight: 400)
    }
}
