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
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
