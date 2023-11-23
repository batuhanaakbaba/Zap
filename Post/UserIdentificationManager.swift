//
//  UserIdentificationManager.swift
//  Zap
//
//  Created by Batuhan Akbaba on 23.11.2023.
//



import Firebase
import FirebaseDatabase

class UserIdentificationManager {
    static let shared = UserIdentificationManager()

    private init() {}

    func assignUserIDIfNeeded() {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            // Kullanıcı daha önce bir kimlik almışsa ve bu kimliği kullanabilir
            print("Kullanıcı zaten bir kimliğe sahip: \(userID)")
            useExistingUserID(userID)
           

        } else {
            // Kullanıcıya yeni bir kimlik atama
            let newUserID = generateUniqueUserID()
            
            // Firebase veritabanına kimliği kaydetme
            saveUserIDToFirebase(userID: newUserID)
            
            // Kullanıcı kimliğini yerel olarak saklama
            UserDefaults.standard.set(newUserID, forKey: "userID")
            print("Yeni kimlik atandı: \(newUserID)")
        }
    }

    private func generateUniqueUserID() -> String {
        return shortUUID()
    }


    private func saveUserIDToFirebase(userID: String) {
        let databaseRef = Database.database().reference()
        let usersRef = databaseRef.child("Users").child(userID)
        let updates: [String: Any] = [
            "userID": userID,
            "username": "zapper",
            "premium": false]
        // Kullanıcı kimliğini Firebase Realtime Database'e ekleme
       usersRef.updateChildValues(updates) { (error, _) in
            if let error = error {
                print("Kategori ve video bilgileri güncellenirken bir hata oluştu: \(error.localizedDescription)")
            } else {
                print("Kategori ve video bilgileri başarıyla güncellendi!")
                
            }
        }

    }


    private func useExistingUserID(_ userID: String) {
        // Kullanıcı daha önce bir kimlik almışsa, istediğiniz işlemleri gerçekleştirin
        print("Kullanıcı daha önce bir kimlik almış ve şu anda bu kimliği kullanıyor: \(userID)")
        // Örneğin, Firebase ile oturum açma işlemlerini burada gerçekleştirebilirsiniz.
    }
}


