import ProgressHUD

final class LoadingIndicator {
    static func show() {
        ProgressHUD.show()
    }
    
    static func hide() {
        ProgressHUD.dismiss()
    }
}
