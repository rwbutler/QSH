//
//  CommandLineImagesService.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation
import ShellOut

struct CommandLineImagesService: ImagesService {
    func showImage(questionId: UUID,  image: Data) {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let currentDirURL = URL(fileURLWithPath: currentPath, isDirectory: true)
        let imageName = questionId.uuidString
        let imageURL = currentDirURL.appendingPathComponent(imageName)
        try? image.write(to: imageURL)
        if let output = try? shellOut(to: "open", arguments: [imageName]) {
            print(output)
        }
    }
}
