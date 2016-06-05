import Foundation
import KituraNet

/// Logging middleware.
public final class Logger: KirHandler {

	public static let Prefix = "[kir]"

	/**
		Log the message by prepending the class prefix.

		- parameter message: The message to log
	*/
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