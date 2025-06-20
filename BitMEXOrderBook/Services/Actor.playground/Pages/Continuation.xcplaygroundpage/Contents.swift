//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

@MainActor
func fetchUser(completion: @escaping (Result<String, Error>) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        completion(.success("khanh"))
    }
}


fetchUser { result in
    switch result {
    case .success(let name):
        print("Lấy tên thành công: \(name)")
    case .failure(_):
        print("Lấy tên false")
    }
}


func fetchUserAsync() async throws -> String {
    try await withCheckedThrowingContinuation { continuation in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            continuation.resume(returning: "khanh")
        }
    }
}


Task {
    do {
        let name = try await fetchUserAsync()
        print("name \(name)")
    } catch {
        
    }
}
