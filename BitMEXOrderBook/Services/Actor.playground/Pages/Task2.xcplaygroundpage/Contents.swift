//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

//Task 2: Parallel Image Downloader
//Given:
//
//func getImageURLs() -> [URL] returns a list of image URLs.
//
//func downloadImage(from url: URL) async -> Data downloads image data.
//
//Your task:
//
//Download all images in parallel.
//
//Return a dictionary [URL: Data].


func getImagesURLs() -> [URL]{
    return [
        URL(string: "https://dummyimage.com/300.png")!,
        URL(string: "https://dummyimage.com/400.png")!,
        URL(string: "https://dummyimage.com/500.png")!
    ]
}


func downloadImage(url: URL) async -> Data {
    try? await Task.sleep(for: .seconds(1))
    return Data("data of \(url)".utf8)
}

func fetchAllImages() async -> [URL: Data] {
    let urls = getImagesURLs()

    var result: [URL: Data] = [:]
    await withTaskGroup(of: (URL, Data).self) { group in
        for url in urls {
            group.addTask {
                var data = await downloadImage(url: url)
                return (url, data)
            }
        }
        
        for await (url, data) in group {
            result[url] = data
        }
    }
    
    return result
}


Task {
    let images =  await fetchAllImages()
    print(images)
}

