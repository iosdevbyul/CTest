//
//  FileProcessor.swift
//  CTest
//
//  Created by PNT001 on 1/23/24.
//

import Foundation

actor FileProcessor {
    
    private let fileManager = FileManager.default
    private var fileWaitList = WaitingList()
    private let dm = DeliveryManager()
    
    func prepareFile(_ dataForm: DataForm) {
        let name = getFileName()
        
        do {
            let jsonData = try JSONEncoder().encode(dataForm)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            do {
                let filePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let new = filePath.appendingPathComponent(name)
                
                if let data = jsonString.data(using: .utf8) {
                    do {
                        try data.write(to: new)
                        print("Successfully wrote to file!")
                    } catch {
                        print("Error writing to file: \(error)")
                    }
                }

                let destinationURL = new.appendingPathExtension("gz")

                do {
                    let data = try Data(contentsOf: new)
                    try data.gzipped().write(to: destinationURL)
                    print("zipped to \(destinationURL)")
                    deleteFile(new)
                    
                    fileWaitList.push(destinationURL)
                    sendFile()
                } catch {
                  print("Fail to zip because \(error.localizedDescription)")
                }
            }
        } catch { print(error) }
    }
    
    private func sendFile() {
        var failList: [URL] = []
        
        while !fileWaitList.isEmpty {
            if let target = fileWaitList.pop() {
                Task {
                    await dm.send(target) { res in
                        if res {
                            self.deleteFile(target)
                        } else {
                            failList.append(target)
                        }
                    }
                }
            }
        }
        
        if failList.count != 0 {
            for fail in failList {
                fileWaitList.push(fail)
            }
        }
    }

    func deleteFile(_ target: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: target)
            print("The file's been removed")
            
        } catch {
            print("fail to delete the targeted file")
        }
    }
    
    private func getFileName() -> String {
        let timestamp = NSDate().timeIntervalSince1970
        return "\(timestamp)"
    }
}
