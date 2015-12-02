//
//  PhotoManager.swift
//  NutriWeekApp
//
//  Created by Gabriel Maciel Bueno Luna Freire on 26/11/15.
//  Copyright © 2015 Gabarron. All rights reserved.
//

import Foundation
import Photos

class PhotoManager {
    
    var placeholder: PHObjectPlaceholder!
    var album: PHAssetCollection!
    private let albumTitle = "NutriWeek"
    
    func savePhoto(image: UIImage) {
        
        self.loadAlbumWithTitleExist(self.albumTitle)
        if album != nil {
            self.addAssetToAlbum(image)
        }
        else {
            // Create Album
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                // Request creating an album from the textfield
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumTitle)
                
                // Store placeholder object for use later
                self.placeholder = createAlbumRequest.placeholderForCreatedAssetCollection;
                
                }, completionHandler: {(success, error)in
                    
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.placeholder.localIdentifier], options: nil)
                    
                    print(collectionFetchResult.firstObject)
                    self.album = collectionFetchResult.firstObject as! PHAssetCollection
                    
                    // [self addAssetToAssetCollection:[collectionFetchResult firstObject]];
                    
                    self.addAssetToAlbum(image)
                    
            })
        }
    }
    
    private func addAssetToAlbum(image: UIImage) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            self.placeholder = createAssetRequest.placeholderForCreatedAsset
            let photoAsset = PHAsset.fetchAssetsInAssetCollection(self.album, options: nil)
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.album, assets: photoAsset)
            albumChangeRequest?.addAssets([self.placeholder!])
            
            }, completionHandler: {(success, error)in
                print(self.placeholder)
                print("\nSave Image -> ", (success ? "Success" : "Error!"))
        })
    }
    
    private func loadAlbumWithTitleExist(title:String) -> Bool {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumTitle)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        if collection.firstObject != nil {
            self.album = collection.firstObject as! PHAssetCollection
            return true
        } else {
            return false
        }
    }
}