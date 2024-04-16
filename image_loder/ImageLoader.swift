//
//  ImageLoader.swift
//  image_loder
//
//  Created by Mahipal on 16/04/24.
//

import Foundation

import SwiftUI

struct CachedImageView: View {
    @ObservedObject private var imageLoader: ImageLoader
    
    init(url: String) {
        
        _imageLoader = ObservedObject(initialValue:  ImageLoader(url: URL(string: url)))
    }
    
    var body: some View {
        VStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                   
            } else if let error = imageLoader.error {
                    Text(error)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
            } else {
                ProgressView()
            }
        }
        .frame( height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onAppear {
            imageLoader.loadImage()
        }
        
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var error: String?
    
    private let url: URL?
    private let cache = NSCache<NSURL, UIImage>()
    
    init(url: URL?) {
        self.url = url
      
    }
    
     func loadImage() {
        guard let url else {
            self.error = "Invalid URL."
            return
        }
        print(url)
        if let cachedImage = cache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        // Load image from disk cache if available
        if let diskImage = loadImageFromDiskCache() {
            cache.setObject(diskImage, forKey: url as NSURL)
            self.image = diskImage
            return
        }
        
        // Fetch image from URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
           
            guard let data = data, let fetchedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.error = "Unable to load image."
                }
                return
            }
            
            // Cache image in memory
            self.cache.setObject(fetchedImage, forKey: url as NSURL)
            
            // Cache image in disk
            self.saveImageToDiskCache(image: fetchedImage)
            
            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }
        task.resume()
    }
    
    private func saveImageToDiskCache(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8),
           let filePath = filePathForImage() {
            try? data.write(to: filePath, options: .atomic)
        }
    }
    
    private func loadImageFromDiskCache() -> UIImage? {
        guard let filePath = filePathForImage(),
              let imageData = FileManager.default.contents(atPath: filePath.path) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    private func filePathForImage() -> URL? {
        guard let url else { return nil }
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileName = url.absoluteString
        return documentsDirectory?.appendingPathComponent(fileName)
    }
}

