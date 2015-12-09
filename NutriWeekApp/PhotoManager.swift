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
    
    private var placeholder: PHObjectPlaceholder!
    private var album: PHAssetCollection!
    
    private let albumTitle = "NutriWeek"
    
    func getPhoto(imageIdentifier:String, onCompletion: (UIImage) -> Void) {
        
        self.loadAlbumWithTitleExist(self.albumTitle)
        if album != nil {
            self.getAssetToAlbum(imageIdentifier) {
                image in
                onCompletion(image)
            }
        }
        else {
            self.createAlbum() {
                (success, error)in
                let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.placeholder.localIdentifier], options: nil)
                
                print(collectionFetchResult.firstObject)
                self.album = collectionFetchResult.firstObject as! PHAssetCollection
                
                // [self addAssetToAssetCollection:[collectionFetchResult firstObject]];
                
                self.getAssetToAlbum(imageIdentifier) {
                    image in
                    onCompletion(image)
                }
            }
        }
    }
    
    func savePhoto(image: UIImage, onCompletion: (String) -> Void) {
        
        self.loadAlbumWithTitleExist(self.albumTitle)
        if album != nil {
            self.addAssetToAlbum(image) {
                imageIdentifier in
                onCompletion(imageIdentifier)
            }
        }
        else {
            self.createAlbum() {
                (success, error)in
                let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.placeholder.localIdentifier], options: nil)
                
                print(collectionFetchResult.firstObject)
                self.album = collectionFetchResult.firstObject as! PHAssetCollection
                
                // [self addAssetToAssetCollection:[collectionFetchResult firstObject]];
                
                self.addAssetToAlbum(image) {
                    imageIdentifier in
                    onCompletion(imageIdentifier)
                }
            }
        }
    }
    
    private func addAssetToAlbum(image: UIImage, onCompletion: (String) -> Void) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            self.placeholder = createAssetRequest.placeholderForCreatedAsset
            let photoAsset = PHAsset.fetchAssetsInAssetCollection(self.album, options: nil)
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.album, assets: photoAsset)
            albumChangeRequest?.addAssets([self.placeholder!])
            
            }, completionHandler: {(success, error)in
                print("\nSave Image -> ", (success ? "Success" : "Error!"))
                onCompletion(self.placeholder.localIdentifier)
        })
    }
    
    private func getAssetToAlbum(imageIdentifier:String, onCompletion: (UIImage) -> Void) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "localIdentifier = %@", imageIdentifier)
        
        let assets : PHFetchResult = PHAsset.fetchAssetsInAssetCollection(self.album, options: fetchOptions)
        print(assets)
        
        let imageManager = PHCachingImageManager()
        
        assets.enumerateObjectsUsingBlock{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset {
                let asset = object as! PHAsset
                print(asset)
                
                if asset.localIdentifier == imageIdentifier {
                
                    let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                
                    let options = PHImageRequestOptions()
                
                    imageManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: .AspectFill, options: options, resultHandler: {
                        (image: UIImage?, info: [NSObject : AnyObject]?) in
                        //                    print(info)
                        onCompletion(image!)
                    })
                }
            }
            
        }
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
    
    private func createAlbum(onCompletion: (Bool, NSError?) -> Void) {
        
        // Create Album
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            // Request creating an album from the textfield
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumTitle)
            
            // Store placeholder object for use later
            self.placeholder = createAlbumRequest.placeholderForCreatedAssetCollection;
            
            }, completionHandler: {(success, error)in
                onCompletion(success, error)
                
        })
    }
}