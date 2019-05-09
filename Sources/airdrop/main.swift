import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSSharingServiceDelegate {
    var urls: [NSURL]

    init<T: Collection>(urls: T) where T.Element == String {
        self.urls = urls.map { NSURL.init(string: $0)! }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let shareService = NSSharingService.init(named: NSSharingService.Name.sendViaAirDrop)
        shareService!.delegate = self
        shareService!.perform(withItems: self.urls)
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
