import Foundation
import SQLite3

// Structure to store chat response data
struct ChatResponse {
    var id: Int
    var question: String
    var answer: String
}

// Class to manage SQLite operations
class DatabaseManager {
    var db: OpaquePointer?
    
    init() {
        connectDatabase()
        initializeDatabase()
    }
    
    // Function to connect to the SQLite database
    func connectDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ApolloHoloFi.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            print("Database opened successfully.")
        }
    }
    
    // Function to initialize the database and create the Responses table
    func initializeDatabase() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Responses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL);
        """
        
        if sqlite3_exec(db, createTableString, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
        } else {
            print("Responses table created or already exists.")
        }
    }
    
    // Function to insert a chat response into the database
    func insertResponse(response: ChatResponse) {
        let insertStatementString = "INSERT INTO Responses (question, answer) VALUES (?, ?);"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertStatementString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (response.question as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (response.answer as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Response inserted successfully.")
            } else {
                print("Error inserting response.")
            }
        } else {
            print("Error preparing statement.")
        }
        
        sqlite3_finalize(statement)
    }
    
    // Function to read a response based on the question
    func getResponse(for question: String) -> String? {
        let queryStatementString = "SELECT answer FROM Responses WHERE question = ?;"
        var statement: OpaquePointer?
        var answer: String? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (question as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                if let cString = sqlite3_column_text(statement, 0) {
                    answer = String(cString: cString)
                }
            } else {
                print("No response found for the question.")
            }
        } else {
            print("Error preparing statement.")
        }
        
        sqlite3_finalize(statement)
        return answer
    }
    
    // Close the database
    func closeDatabase() {
        sqlite3_close(db)
        print("Database closed.")
    }
}

// Main function to run the application
func main() {
    let dbManager = DatabaseManager()
    
    // Insert sample responses
    dbManager.insertResponse(response: ChatResponse(id: 1, question: "What is HoloFi?", answer: "HoloFi is a blockchain-based platform."))
    dbManager.insertResponse(response: ChatResponse(id: 2, question: "How does it work?", answer: "It uses smart contracts for transactions."))

    // Example of querying a response
    if let response = dbManager.getResponse(for: "What is HoloFi?") {
        print("Chatbot: \(response)")
    } else {
        print("Chatbot: I don't know the answer to that.")
    }

    // Close the database
    dbManager.closeDatabase()
}

// Run the main function
main()
