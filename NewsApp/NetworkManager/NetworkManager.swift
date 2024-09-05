import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseUrlString = "https://newsapi.org/v2/"
    private let USTopHeadlines = "top-headlines?country=us&apiKey=\(APIKey.api)"

    func fetchNews(completion: @escaping ([NewsResponce]?) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=bb15380e582745af81c530b94b77ccd5") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching news: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            do {
                let newsEnvelope = try JSONDecoder().decode(NewsEnvelope.self, from: data)
                completion(newsEnvelope.articles)
            } catch {
                print("Error decoding news data: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    func getImage(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid image URL: \(urlString)")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received for image")
                completion(nil)
                return
            }
            completion(data)
        }.resume() 
    }
}
