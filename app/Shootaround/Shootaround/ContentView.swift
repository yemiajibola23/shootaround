//
//  ContentView.swift
//  Shootaround
//
//  Created by Yemi Ajibola on 10/5/26.
//

import SwiftUI
import SM2Scheduler
import SwiftData
internal import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isImporting = false
    @Environment(\.modelContext) private var context
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Import Deck") { isImporting = true }
                .fileImporter(isPresented: $isImporting, allowedContentTypes: [.commaSeparatedText]) { result in
                    switch result {
                    case .success(let url):
                        do {
                            _ = try importDeckFile(from: url, into: context)
                        } catch {
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
