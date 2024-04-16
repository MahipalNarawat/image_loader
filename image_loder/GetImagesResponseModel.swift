//
//  GetImagesResponseModel.swift
//  image_loder
//
//  Created by Mahipal on 16/04/24.
//

import Foundation

struct GetImagesResponseModel: Decodable {
    let id, title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

struct Thumbnail: Decodable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Int
}

struct BackupDetails: Decodable {
    let pdfLink: String
    let screenshotURL: String
}

