//
//  NetworkService.swift
//  GeniuseeMovieFinder
//
//  Created by Victor Pelivan on 25.06.2020.
//  Copyright © 2020 Viktor Pelivan. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func getData<T: Decodable>(into type: T.Type, from url: URL, completion: @escaping (T?) -> ())
    func getImage(from url: URL, completion: @escaping (UIImage?)->())
}

class NetworkService: NetworkServiceProtocol {
    
    //MARK: - Variables
    public var imageCache = NSCache<NSString, UIImage>() //Image Cache Class
    
    //MARK: - Public Methods
    /* Using A Generic Argument in this method to be able to create universal function for parsing any model type with completion handler closure escaping condition */
    public func getData<T: Decodable>(into type: T.Type, from url: URL, completion: @escaping (T?) -> ()) {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    do
                    {
                        print("Status code: ", httpResponse.statusCode)
                        guard let data = data else { return }
                        let decodedData = try JSONDecoder().decode(type.self, from: data)
                        completion(decodedData)
                    }
                    catch let error {
                        completion(nil)
                        print(error.localizedDescription)
                    }
                }
            } else {
                completion(nil)
                let alertMessage = "For some reasons the request could not be performed"
                self.alert(withTitle: "Request Error", message: alertMessage)
                return
            }
        }
        task.resume()
    }
    
    /* Next method performs image load request in case if it is not cached already, and if it is cached, it just pulls it from cache. It also handles right status codes and errors */
    public func getImage(from url: URL, completion: @escaping (UIImage?)->()) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) { // Checking if an image is already cached
            completion(cachedImage)
        } else { // if an image is not cached, we perform request
            var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                DispatchQueue.main.async {
                    guard let response = (response as? HTTPURLResponse), (200...299).contains(response.statusCode), error == nil, let data = data, let image = UIImage(data: data) else {
                        print("Image Request Error: ", error?.localizedDescription ?? "")
                        completion(nil)
                        return
                    }
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image)
                }
            }.resume()
        }
    }
    
    //MARK: - Private Methods
    /* This alert shows in case if the response status code is not valid for loading data */
    private func alert(withTitle title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(ok)
        UIApplication.topViewController()?.present(ac, animated: true)
    }
}
