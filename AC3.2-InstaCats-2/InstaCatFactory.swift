//
//  InstaCatFactory.swift
//  AC3.2-InstaCats-2
//
//  Created by Louis Tur on 10/11/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit


/// Used to create `[InstaCat]`
class InstaCatFactory {

    static let manager: InstaCatFactory = InstaCatFactory()
    private init() {}
    
    
    /// Attempts to make `[InstaCat]` from the `Data` contained in a local file
    /// - parameter filename: The name of the file containing json-formatted data, including its extension in the name
    /// - returns: An array of `InstaCat` if the file is located and has properly formatted data. `nil` otherwise.
    class func makeInstaCats(fileName: String) -> [InstaCat]? {
        
        // Everything from viewDidLoad in InstaCatTableViewController has just been moved here
        guard let instaCatsURL: URL = InstaCatFactory.manager.getResourceURL(from: fileName),
            let instaCatData: Data = InstaCatFactory.manager.getData(from: instaCatsURL),
            let instaCatsAll: [InstaCat] = InstaCatFactory.manager.getInstaCats(from: instaCatData) else {
                return nil
        }
        
        return instaCatsAll
    }
    
    
    /// Gets the `URL` for a local file
    fileprivate func getResourceURL(from fileName: String) -> URL? {
        
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
        
        return fileURL
    }
    
    /// Gets the `Data` from the local file located at a specified `URL`
    fileprivate func getData(from url: URL) -> Data? {
        
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    
    // MARK: - Data Parsing
    /// Creates `[InstaCat]` from valid `Data`
    internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
        
        do {
            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Cast from Any and check for the "cats" key
            guard let instaCatJSONCasted: [String : AnyObject] = instaCatJSONData as? [String : AnyObject],
                let instaCatArray: [AnyObject] = instaCatJSONCasted["cats"] as? [AnyObject] else {
                    return nil
            }
            
            var instaCats: [InstaCat] = []
            instaCatArray.forEach({ instaCatObject in
                guard let instaCatName: String = instaCatObject["name"] as? String,
                    let instaCatIDString: String = instaCatObject["cat_id"] as? String,
                    let instaCatInstagramURLString: String = instaCatObject["instagram"] as? String,
                    
                    // Some of these values need further casting
                    let instaCatID: Int = Int(instaCatIDString),
                    let instaCatInstagramURL: URL = URL(string: instaCatInstagramURLString) else {
                        return
                }
                
                // append to our temp array
                instaCats.append(InstaCat(name: instaCatName, id: instaCatID, instagramURL: instaCatInstagramURL))
            })
            
            return instaCats
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }
    
}



class InstaDogFactory{
    static let manager: InstaDogFactory = InstaDogFactory()
    private init() {}
    
    class func makeInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void){
        if let instaDogsURL: URL = URL(string: apiEndpoint){
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: instaDogsURL){ (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil{
                    print(error!)
                }
                
                if let dogsData: Data = data {
                    print(dogsData)
                    if let instaDog: [InstaDog] = InstaDogFactory.manager.getInstaDogs(from: dogsData){
                        dump(instaDog)
                        callback(instaDog)
                    }
                }
            }.resume()
        }
    }

    internal func getInstaDogs(from jsonData: Data) -> [InstaDog]?{
        do {
            let instaDogData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            guard let instaDogCasted: [String: AnyObject] = instaDogData as? [String: AnyObject],
                let instaDogArr: [AnyObject] = instaDogCasted["dogs"] as? [AnyObject] else {
                return nil
            }
            
            var instaDogs: [InstaDog] = []
            instaDogArr.forEach({ instaDogObject in
                guard let id: String = instaDogObject["dog_id"] as? String,
                    let name: String = instaDogObject["name"] as? String,
                    let instagram: String = instaDogObject["instagram"] as? String,
                    let imageName: String = instaDogObject["imageName"] as? String,
                    let stats: [String: Any] = instaDogObject["stats"] as? [String: Any],
                    let followers: String = stats["followers"] as? String,
                    let following: String = stats["following"] as? String,
                    let posts: String = stats["posts"] as? String else{
                    return
                }
                
                instaDogs.append(InstaDog(id: id, name: name, instagram: instagram, imageName: imageName, follower: followers, following: following, posts: posts))
            })
            return instaDogs
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
