import Cocoa
import CreateML

// Load the dataset from a CSV file located at the specified path
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/javierhammad/Desktop/swift course/Twittermenti-iOS13/twitter-sanders-apple3.csv"))

// Split the dataset randomly into training and testing subsets, with 80% for training and 20% for testing
let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5 )

// Train a text classifier using the training data, specifying the text and label columns
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

// Evaluate the performance of the classifier on the testing data
let evaluationMetric = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

// Calculate the evaluation accuracy as a percentage
let evaluationAccuracy = (1.0 - evaluationMetric.classificationError)*100

// Metadata for the trained model
let metada = MLModelMetadata(author: "Javier Hammad", shortDescription: "A model trained to classify sentiment on tweets", version: "1.0")

// Save the trained model to a Core ML model file at the specified path
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/javierhammad/Desktop/swift course/Twittermenti-iOS13/TweetSentimentClassifier.mlmodel"))

// Make predictions using the trained model on sample input text
try sentimentClassifier.prediction(from: "@Apple is  a terrible company!")
try sentimentClassifier.prediction(from: "@Apple is  a great company!")
try sentimentClassifier.prediction(from: "@Apple is ok")

