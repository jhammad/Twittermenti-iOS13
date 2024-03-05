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
            var tweets = [TweetSentimentClassifierInput]()
            // Iterate through a range of indices from 0 to 99.
            for i in 0..<100 {
                // Check if the "full_text" field exists in the result at index 'i'.
                if let tweet = results[i]["full_text"].string {
                    // If the "full_text" field exists, create a TweetSentimentClassifierInput object with the tweet text.
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    // Append the created TweetSentimentClassifierInput object to the 'tweets' array.
                    tweets.append(tweetForClassification)
                }
            }
            do {
                // Attempt to make sentiment predictions using the sentiment classifier model with the 'tweets' array.
                let predictions = try sentimentClassifier.predictions(inputs: tweets)
                // variable to keep the sentimentScore
                var sentimentScore = 0
                // iterate through predictions
                for prediction in predictions {
                    // new variable form the label
                    let sentiment = prediction.label
                    // if positive + 1
                    if sentiment == "Pos" {
                        sentimentScore += 1
                    }
                    // if negatiove -1
                    else if sentiment == "Neg" {
                        sentimentScore -= 1
                    }
                }
                print(sentimentScore)
            } catch {
                // If there is an error while making predictions, print an error message.
                print("There was an error with making a prediction, \(error)")
            }

            // Handle errors that occur during the Twitter API request.
            }) { (error) in
                print("Error fetching tweets with the Twitter API request, \(error)")
            }
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
    }
    
}

