import LumiUI
import SwiftUI

/// Shared iOS settings navigation content.
///
/// The host app owns the window or sheet that presents this view.
@MainActor
public struct IOSSettingsNavigationView<Provider: SettingViewProviding>: View {
    let provider: Provider
    @State private var path: [String] = []
    @State private var observationRevision = 0
    @State private var observerHandle: (any SettingViewObserverHandle)?

    public init(provider: Provider) {
        self.provider = provider
    }

    public var body: some View {
        NavigationStack(path: $path) {
            List(provider.entries) { entry in
                NavigationLink(value: entry.id) {
                    Label(entry.title, systemImage: entry.systemImage)
                }
            }
            .navigationTitle(LumiUILocalization.string("Settings"))
            .navigationDestination(for: String.self) { id in
                if let entry = provider.entries.first(where: { $0.id == id }) {
                    entry.makeDetailView()
                        .navigationTitle(entry.title)
                } else {
                    ContentUnavailableView(
                        LumiUILocalization.string("Setting unavailable"),
                        systemImage: "gearshape"
                    )
                }
            }
        }
        .onChange(of: path) { _, newPath in
            provider.selectEntry(id: newPath.last)
        }
        .onChange(of: observationRevision) { _, _ in }
        .onAppear {
            guard observerHandle == nil else { return }
            observerHandle = provider.addSettingViewObserver { _ in
                observationRevision += 1
            }
        }
        .onDisappear {
            observerHandle?.cancel()
            observerHandle = nil
        }
    }
}
