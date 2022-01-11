//
//  ImageLoaderView.swift
//  Weather
//
//  Created by Tino on 11/1/22.
//

import SwiftUI

struct ImageLoaderView<V: View, P: View>: View {
    let url: URL?
    @StateObject var imageLoader: ImageLoader
    let content: (Image) -> V
    let placeholder: (() -> P)
    
    init(url: URL?,
         content: @escaping (Image) -> V,
         placeholder: @escaping (() -> P)
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            switch imageLoader.state {
            case .loaded:
                content(imageLoader.image!)
            case .loading:
                placeholder()
            case .error:
                Text("Failed to load image")
            }
        }
        .task {
            await imageLoader.load()
        }
    }
}

struct ImageLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderView(url: URL(string: "https:google.com/")) { image in
            Text("image")
        } placeholder: {
            Text("placeholder")
        }
    }
}
