import UIKit
import Foundation

struct AppResponse: Decodable {
    let results: [App]
}

struct App: Decodable {
    let name: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case rating = "averageUserRating"
    }
}

func fetchApps() {
    print("started...")
    let urlString = "http://itunes.apple.com/search?entity=software&term=Zoho%20Corporation"
    guard let url = URL(string: urlString) else { return }
    
    print("loading.....")
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Failed to fetch data:", error ?? "Unknown error")
            return
        }

        do {
            let appResponse = try JSONDecoder().decode(AppResponse.self, from: data)
            
            for app in appResponse.results {
                print("App Name: \(app.name), Rating: \(app.rating)")
            }
        } catch {
            print("Failed to decode JSON:", error)
        }
        print("apps exited")

    }.resume()
    
    print("resume ended")
}
fetchApps()
