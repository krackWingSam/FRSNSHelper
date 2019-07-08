//
//  InstagramHelper.swift
//  RecipeFarm
//
//  Created by exs-mobile 강상우 on 25/06/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import Photos

class InstagramHelper: NSObject {
    static let shared = InstagramHelper()
    
    // MARK: - Class func
    class func shareInstagram(_ base64String: String) {
        saveImage(base64String)
    }
    
    private class func checkAuth() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            return true
        }
        return false
    }
    
    class func createAlbum(_ handler: @escaping (PHAssetCollection?)->Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "RecipeFarm")
        }) { (status, error) in
            if error != nil {
                print(error.debugDescription)
            }
            getAlbum(handler)
        }
    }
    
    private class func getAlbum(_ handler: @escaping (PHAssetCollection?)->Void) {
        let albums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
        var album : PHAssetCollection? = nil
        albums.enumerateObjects { (collection, i, stop) in
            if collection.localizedTitle == "RecipeFarm" {
                album = collection
            }
        }
        
        if album == nil {
            createAlbum(handler)
            return
        }
        
        handler(album)
    }
    
    private class func writeImageInAlbum(_ base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return }
        guard let image = UIImage(data: data) else { return }
        getAlbum { (album) in
            guard let album = album else { return }
            var localID: String?
            PHPhotoLibrary.shared().performChanges({
                let asset = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceholder = asset.placeholderForCreatedAsset
                let enumeration: NSArray = [assetPlaceholder!]
                let request = PHAssetCollectionChangeRequest(for: album)
                request!.addAssets(enumeration)
                
                localID = assetPlaceholder?.localIdentifier
            }, completionHandler: { (success, error) in
                guard let id = localID else { return }
                openInstagram(id)
            })
            print()
        }
    }
    
    private class func saveImage(_ base64String: String) {
        if checkAuth() {
            writeImageInAlbum(base64String)
        }
        else {
            PHPhotoLibrary.requestAuthorization { (status) in
                if checkAuth() == false { return }
                writeImageInAlbum(base64String)
            }
        }
    }
    
    private class func openInstagram(_ localID: String) {
        guard let url = URL(string: "instagram://library?OpenInEditor=1&LocalIdentifier=\(localID)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
