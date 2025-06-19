import UIKit
import Foundation


//`getCountries`: returns a list of country names
//- `getPopulation`: returns the population of a country
//
//The task is to asynchronously create a dictionary where:
//
//- `[String: Int]` keys: country name, values: population

//prepare 2 function getCountries and get population

print("hello world")

let mockCountries: [String] = ["France", "Germany", "Italy"]


func getCountries() async -> [String] {
    return mockCountries
}

func getPopulation(country:String) async -> Int {
    switch country {
    case "France": return 600000
    case "Germany": return 1200000
    case "Italy": return 60000
    default: return 0
    }
}

actor ResultCollector {
    private var data: [String: Int] = [:]
    
    func set(_ country: String, population: Int) {
        data[country] = population
    }
    
    func get() -> [String: Int] {
        return data
    }
}




func createCountryPopulationDict() async -> [String: Int] {
    let countries = await getCountries()
    let serialQueue = DispatchQueue(label: "com.example.serialQueue")
    let collector = ResultCollector()
    // using actor there to prevent potential race condition
    await withTaskGroup(of: Void.self) { group in
        for country in countries {
            group.addTask {
                let population = await getPopulation(country: country)
                await collector.set(country, population: population)
            }
        }

    }
    
    return await collector.get()
    
}


Task {
    let dictionary = await createCountryPopulationDict()
    print(dictionary)
}






