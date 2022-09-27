//
//  LocalFileManager.swift
//  Crypto
//
//  Created by PC on 27/09/22.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    private init(){}

    func saveImage(image: UIImage, imageName: String, foldernName: String){

        //create folder
        createFolderIfNeeded(folderName: foldernName)

        //get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, foldernName: foldernName)
            else {return}

        //save Image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(error)")
        }
    }

    func getImage(ImageName: String, folderName: String) -> UIImage?{
        guard
            let url = getURLForImage(imageName: ImageName, foldernName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
                return nil
        }
        return UIImage(contentsOfFile: url.path)

    }

    private func createFolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(foldernName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directr. \(folderName). \(error)")
            }
        }
    }

    private func getURLForFolder(foldernName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }

        return url.appendingPathComponent(foldernName)
    }

    private func getURLForImage(imageName: String, foldernName: String) -> URL?{
        guard let folderURl = getURLForFolder(foldernName: foldernName) else {return nil}

        return folderURl.appendingPathComponent(imageName + ".png")

    }
}
