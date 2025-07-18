import UIKit

protocol JailbreakChecker {
    func isJailbroken() -> Bool
}

class DefaultJailbreakChecker: JailbreakChecker {
    func isJailbroken() -> Bool {
        if !Platform.isSimulator {
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
                return true
            }
            do {
                try "Test".write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: .utf8)
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
}

class AppUtility {
    static func getJailbrokenStatus(using checker: JailbreakChecker = DefaultJailbreakChecker()) -> Bool {
        return checker.isJailbroken()
    }
}

struct Platform {
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

extension UIImageView {
    /// Downloads an image asynchronously and sets it to the image view.
    /// - Parameter urlString: The URL string of the image.
    func setImage(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
