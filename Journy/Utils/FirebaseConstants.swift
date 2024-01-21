import FirebaseFirestore

typealias FirestoreCompletion = ((Error?) -> Void)?

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_PASSIONS = Firestore.firestore().collection("passions")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
