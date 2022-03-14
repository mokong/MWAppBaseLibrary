//
//  MWAppBaseFileManager.swift
//  MWAppBase
//
//  Created by MorganWang on 8/3/2022.
//

import Foundation
import UIKit


let AlbumDir = "MWPhotoAlbumDir"

/// 操作本地文件夹类
class MWAppBaseFileManager {
    
    
    /// 删除指定目录下指定图片
    /// - Parameters:
    ///   - imageName: 图片名字
    ///   - dirName: 文件夹名字
    class func deleteAppAlbumImage(with imageName: String, from dirName: String) {
        // 获取文件夹
        let targetCacheURL = MWAppBaseFileManager.targetCachePath(with:  dirName)
        
        let fileName = String(format: "%@.jpg", imageName)
        let fileURL = targetCacheURL?.appendingPathComponent(fileName)

        MWAppBaseFileManager.deleteFile(in: fileURL!)
    }
    
    /// 删除指定路径的文件
    /// - Parameter filePath: 文件路径
    class func deleteFile(in fileURL: URL) {
        let fileManager = FileManager.default
        let isFileExist = fileManager.fileExists(atPath: fileURL.path)
        if !isFileExist {
            return
        }
        else {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                print(error)
            }
        }
    }
    
    
    /// 返回指定目录下指定图片名字的图片
    /// - Parameters:
    ///   - imageName: 图片名字
    ///   - dirName: 图片目录
    /// - Returns: 图片
    class func getAppAlbumImage(with imageName: String, from dirName: String) -> UIImage? {
        // 获取文件夹
        let targetCacheURL = MWAppBaseFileManager.targetCachePath(with:  dirName)
        let fileName = String(format: "%@.jpg", imageName)
        let fileURL = targetCacheURL?.appendingPathComponent(fileName)
        return MWAppBaseFileManager.getImage(from: fileURL!)
    }
    
    
    /// 从路径中读取图片
    /// - Parameter filePath: 路径
    /// - Returns: 图片
    class func getImage(from fileURL: URL) -> UIImage? {
        do {
            let fileData = try Data(contentsOf: fileURL)
            let image = UIImage(data: fileData)
            return image
        } catch {
            print(error)
            return nil
        }
    }
    
    
    /// 存储照片到指定目录
    /// - Parameters:
    ///   - image: 要存储的照片
    ///   - imageName: 照片名字-图片存储时间 YYYYMMDDHHMMSS
    ///   - dirName: 要存储的文件夹的名字
    class func save(image: UIImage, imageName: String, to dirName: String) {
        // 获取文件夹
        let targetCacheURL = MWAppBaseFileManager.targetCachePath(with:  dirName)
        // 创建缓存目录
        MWAppBaseFileManager.createTargetCacheDir(dirName)

        // 拼接图片名字
        let fileName = String(format: "%@.jpg", imageName)
        let fileURL = targetCacheURL?.appendingPathComponent(fileName)
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        do {
            try imageData?.write(to: fileURL!, options: Data.WritingOptions.atomic)
        } catch {
            print(error)
        }
    }
    
    
    ///  创建缓存文件夹到本地
    /// - Parameter dirName: 要创建的文件夹的名字
    class func createTargetCacheDir(_ dirName: String) {
        // 获取缓存目录
        let targetCacheURL = MWAppBaseFileManager.targetCachePath(with:  dirName)
        
        let manager = FileManager.default
        let haveCreated = manager.fileExists(atPath: targetCacheURL!.path)
        if haveCreated == false {
            do {
                try manager.createDirectory(at: targetCacheURL!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    /// 根据参数生成文件夹
    /// - Parameter dirName: 要生成文件夹名字
    /// - Returns: 文件夹路径
    class func targetCachePath(with dirName: String) -> URL? {
        // 获取系统缓存目录
        let systemCacheURL = MWAppBaseFileManager.systemCacheDir()
        
        // 拼接目录
        let resultDirURL = systemCacheURL?.appendingPathComponent(dirName)
        return resultDirURL
    }
    
    
    /// 获取系统下载文件夹
    /// - Returns: 文件夹路径
    class func systemCacheDir() -> URL? {
        let paths = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        return paths.first
    }
}
