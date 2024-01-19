import FirebaseFirestore

typealias FirestoreCompletion = ((Error?) -> Void)?

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_PASSIONS = Firestore.firestore().collection("passions")
let COLLECTION_POST_GROUPS = Firestore.firestore().collection("post_groups")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
