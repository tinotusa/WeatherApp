//
//  ImageLoader.swift
//  Weather
//
//  Created by Tino on 11/1/22.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    enum LoadingState {
        case loading, error, loaded
    }
    
    let url: URL?
    @Published private(set) var state: LoadingState
    @Published private(set) var image: Image?
    
    init(url: URL?) {
        self.url = url
        state = .loading
    }
    
    @MainActor
    func load() async {
        guard let url = url else {
            state = .error
            return
        }
        do {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            if !(200 ... 299).contains(httpResponse.statusCode) {
                state = .error
                return
            }
            guard let uiImage = UIImage(data: data) else {
                state = .error
                return
            }
            image = Image(uiImage: uiImage)
            state = .loaded
        } catch {
            state = .error
            print("Error: \(#function) failed to load image from url: (\(url.absoluteString))\n\(error)")
        }
    }
}
