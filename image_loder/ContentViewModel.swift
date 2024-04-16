//
//  ContentViewModel.swift
//  image_loder
//
//  Created by Mahipal on 16/04/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var data: [GetImagesResponseModel] = []
    @Published var error: String?
    @Published var loading: Bool = false

    
    init() {
        getImages()
    }
    
    func getImages() {
        loading = true
        Task {
            let result = await getImages()
            await MainActor.run {
                self.data = result
                loading = false
            }
        }
    }
    
    private func getImages() async -> [GetImagesResponseModel] {
        let result = await NetworkHelper.fetchData(from: Endpoints.getImages, responseModel: [GetImagesResponseModel].self)
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            await MainActor.run {
                error = failure.localizedDescription
            }
            return []
        }
    }
}


