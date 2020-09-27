import Cocoa
import FlutterMacOS
import FirebaseAuth
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController.init()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        
        let authChannel = FlutterMethodChannel(
            name: "FirebaseAuthHack",
            binaryMessenger: flutterViewController.engine.binaryMessenger
        )
        
        authChannel.setMethodCallHandler { call, result in
            switch (call.method) {
            case "signInWithCredential":
                signInWithCredential(call.arguments as! Dictionary<String, String?>, result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        RegisterGeneratedPlugins(registry: flutterViewController)
        
        super.awakeFromNib()
    }
}

func signInWithCredential(_ credential: Dictionary<String, String?>, _ result: @escaping FlutterResult) {
    let credential = OAuthProvider.credential(
        withProviderID: credential["providerId"]!!,
        idToken: credential["idToken"]!!,
        rawNonce: credential["rawNonce"]!
    )
    
    Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error as NSError? {
            return result(FlutterError(
                code: String(describing: AuthErrorCode.init(rawValue: error.code)!),
                message: error.localizedDescription,
                details: error
            ))
        }
        
        result(nil)
    }
}
