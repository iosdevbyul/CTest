//
//  NetworkManager.swift
//  CTest
//
//  Created by PNT001 on 1/15/24.
//

import Foundation

actor DeliveryManager {
    
    func send(_ fileUrl: URL, closure: @escaping (Bool) -> Void) {
        //"file:///var/mobile/Containers/Data/Application/E6918E8B-DF12-42CE-B3DA-003E383553EE/Documents/1705302928.407033.gz"
            
        guard let destination: URL = URL(string: "http://175.45.200.117:19091/v1/api/sdk/ios/watch/data/batch-type") else {
                debugPrint("URL is not correct")
                return
        }
          
        var request = URLRequest(url: destination, cachePolicy: .reloadIgnoringLocalCacheData) //to ignore all local cache data
        
        request.addValue("gzip", forHTTPHeaderField: "Content-Encoding")
        request.httpMethod = "POST"

        URLSession.shared.uploadTask(with: request, fromFile: fileUrl) { data, res, error in
            if let response = res as? HTTPURLResponse {
                print("response.statusCode : ",response.statusCode)
                if response.statusCode == 200 {
                    //success to upload the file
                    closure(true)
//                    self.deleteFile(fileUrl)
                } else {
                    closure(false)
                }
            }
        }.resume()
    }
}
