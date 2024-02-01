//Reference
//https://appledb.dev/device-selection/Apple-Watch.html

public extension String {
    
    var type: String {
        
        
        let modelMap : [String: String] = [
            // Apple Watch
            "Watch1,1" : "Apple Watch 1gen",
            "Watch1,2" : "Apple Watch 1gen",
            "Watch2,6" : "Apple Watch Series 1",
            "Watch2,7" : "Apple Watch Series 1",
            "Watch2,3" : "Apple Watch Series 2",
            "Watch2,4" : "Apple Watch Series 2",
            "Watch3,1" : "Apple Watch Series 3",
            "Watch3,2" : "Apple Watch Series 3",
            "Watch3,3" : "Apple Watch Series 3",
            "Watch3,4" : "Apple Watch Series 3",
            "Watch4,1" : "Apple Watch Series 4",
            "Watch4,2" : "Apple Watch Series 4",
            "Watch4,3" : "Apple Watch Series 4",
            "Watch4,4" : "Apple Watch Series 4",
            "Watch5,1" : "Apple Watch Series 5",
            "Watch5,2" : "Apple Watch Series 5",
            "Watch5,3" : "Apple Watch Series 5",
            "Watch5,4" : "Apple Watch Series 5",
            "Watch5,9" : "AppleWatchSE",
            "Watch5,10" : "AppleWatchSE",
            "Watch5,11" : "AppleWatchSE",
            "Watch5,12" : "AppleWatchSE",
            "Watch6,1" : "Apple Watch Series ",
            "Watch6,2" : "Apple Watch Series 6",
            "Watch6,3" : "Apple Watch Series 6",
            "Watch6,4" : "Apple Watch Series 6",
            "Watch6,6" : "Apple Watch Series 7",
            "Watch6,7" : "Apple Watch Series 7",
            "Watch6,8" : "Apple Watch Series 7",
            "Watch6,9" : "Apple Watch Series 7",
            "Watch6,10" : "AppleWatchSE2",
            "Watch6,11" : "AppleWatchSE2",
            "Watch6,12" : "AppleWatchSE2",
            "Watch6,13" : "AppleWatchSE2",
            "Watch6,14" : "Apple Watch Series 8",
            "Watch6,15" : "Apple Watch Series 8",
            "Watch6,16" : "Apple Watch Series 8",
            "Watch6,17" : "Apple Watch Series 8",
            "Watch6,18" : "Apple Watch Ultra",
            "Watch7,1" : "Apple Watch Series 9",
            "Watch7,2" : "Apple Watch Series 9",
            "Watch7,3" : "Apple Watch Series 9",
            "Watch7,4" : "Apple Watch Series 9",
            "Watch7,5" : "Apple Watch Ultra2",
        ]
        
        return modelMap[self] ?? ""
    }
}
