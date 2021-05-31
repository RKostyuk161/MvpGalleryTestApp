//
//  ImagePaginationEntity.swift
//  GalleryTestApp
//
//  Created by Roma on 06.04.2021.
//

import Foundation
import UIKit

struct ImagePaginationEntity: Decodable {
    var data: [OutImageEntity]?
    var countOfPages: Int?
}

struct OutImageEntity: Decodable {
    var id: Int?
    var image: ImageEntityInfo?
    var new: Bool?
    var popular: Bool?
    var name: String?
    var description: String?
}

struct ImageEntityInfo: Decodable {
    var id: Int?
    var name: String?
}
