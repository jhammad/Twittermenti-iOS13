import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // current API not allow toi search in tweets (just placeholder)
    let swifter = Swifter(consumerKey: "consumerKey", consumerSecret: "consumerSecret")

    override func viewDidLoad() {
        super.viewDidLoad()
        // constant from sentimentClassifier
        let sentimentClassifier = try! TweetSentimentClassifier(configuration: MLModelConfiguration())
        do {
            // Attempt to make a prediction using the sentiment classifier
            let prediction = try sentimentClassifier.prediction(text: "@Apple is a terrible company")
            // If successful, prediction contains the result and print the prediction label
            print(prediction.label)
        } catch let error {
            // If an error occurs during prediction, it will be caught here
            // Print the error message
            print("Error making prediction: \(error)")
        }
        // Perform a search for 100 tweets in english mentioning "@Apple" using the swifter library.
        // Options of the search - lang: "en" count: 100 tweetMode .extended will gove all the text form the tweet (not truncated)
        swifter.searchTweet(using: "@Apple", lang: "en", count:100, tweetMode: .extended, success: { (results, searchMetadata) in
            
            // create and empty array of string
            var tweets = [String]()
            
            // for loop in the 100 tweets
            for i in 0..<100 {
                
                // extract the string of the full_text label of the JSON data extracted
                if let tweet = results[i]["full_text"].string {
                    //add the tweets to the empty variable created above
                    tweets.append(tweet)
                }
            }
        }) { (error) in
            print("Error fetching tweets with the twitter API rweques, \(error)")
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    }
    
}

