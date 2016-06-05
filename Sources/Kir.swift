import KituraNet
import KituraSys

// MARK: - Core protocols

/// Delegate protocol for the object that would
/// like to be used as a Middleware
public protocol KirHandler {
	func handle(request: ServerRequest, response: ServerResponse, next: HTTPServerDelegate?)
}

/// Simple wrapper to use a function as middleware
public typealias KirFunctionHandler = (request: ServerRequest, response: ServerResponse, next: HTTPServerDelegate?) -> Void

/// Simple Host for storing function handlers
public struct KirFunctionHost: KirHandler {
	let fn: KirFunctionHandler

	public func handle(request: ServerRequest, response: ServerResponse, next: HTTPServerDelegate?) {
		fn(request: request, response: response, next: next)
	}
}
/// Middleware chain element
public final class Middleware {
	internal let handler: KirHandler
	internal let next: Middleware?

	internal init(handler h: KirHandler, next n: Middleware? = nil) {
		handler = h
		next = n
	}

	public class func wrap(_ handler: HTTPServerDelegate) -> KirHandler {

		let fn: KirFunctionHandler = { request , response, next  in 
			handler.handle(request: request, response: response)

			if let n = next {
				n.handle(request: request, response: response)	
			}	
		}

		return KirFunctionHost(fn: fn)
	}
}

/// Make a middleware callable
extension Middleware: HTTPServerDelegate {
	public func handle(request: ServerRequest, response: ServerResponse) {
		handler.handle(request: request, response: response, next: next)
	}
}

///TODO: Wrapping Methods


// MARK: - Kir Element

public final class Kir {

	private var middleware: Middleware
	private var handlers: [KirHandler]

	public init(handlers hs: KirHandler...) {
		handlers = hs
		middleware = Kir.build(handlers)
	}

	public func use(_ handler: KirHandler) {
		handlers.append(handler)
		middleware = Kir.build(handlers)
	}

	public func useHandler(handler h: HTTPServerDelegate) {
		use(Middleware.wrap(h))
	}

	public func run(port: Int) {
		 let server = HTTP.createServer()
		 server.delegate = middleware
		 server.listen(port: port, notOnMainQueue: false)
		 print("[kir] listening on \(port)")
		 Server.run()
	}

	private class func build(_ handlers: [KirHandler]) -> Middleware {

		var next: Middleware

		if handlers.count == 0 {
			return voidMiddleware
		} else if handlers.count > 1 {
			next = Kir.build(Array(handlers[1..<handlers.count]))
		} else {
			next = voidMiddleware
		}

		return Middleware(handler: handlers[0], next: next)
	}
}	

internal let voidFn: KirFunctionHandler =  { request , response, next  in
}

internal let voidMiddleware: Middleware = Middleware(handler: KirFunctionHost(fn: voidFn))
