import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSSharingServiceDelegate {
    var urls: [NSURL]

    init<T: Collection>(urls: T) where T.Element == String {
        self.urls = urls.map {
            if $0.starts(with: "file://") || $0.starts(with: "https://") || $0.starts(with: "http://") {
                return NSURL.init(string: $0)!
            } else {
                return NSURL.fileURL(withPath: $0) as NSURL
            }
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let service = NSSharingService.init(named: NSSharingService.Name.sendViaAirDrop) {
            service.delegate = self
            service.perform(withItems: self.urls)
        } else {
            exit(-1)
        }
    }

    func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
        exit(0)
    }

    func sharingService(_ sharingService: NSSharingService, didFailToShareItems items: [Any], error: Error) {
        exit(-1)
    }
}

close(2)    // close stderr to disable some nasty log
let delegate = AppDelegate(urls: CommandLine.arguments[1...])
NSApplication.shared.delegate = delegate
NSApplication.shared.run()
