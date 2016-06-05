import Foundation
import KituraNet

/// Logger class
public final class Logger: KirHandler {

	public static let Prefix = "[kir]"

	public func log(_ message: String) {
		print("\(Logger.Prefix) \(message)")
	}

	public func handle(request: ServerRequest, response: ServerResponse, next: HTTPServerDelegate?) {

		let start = NSDate()
		log("Started \(request.method) \(request.urlString)")

		if let n = next {
			n.handle(request: request, response: response)
		}

		log("Completed \(response.statusCode!) in \(NSDate().timeIntervalSince(start))")
	}
}