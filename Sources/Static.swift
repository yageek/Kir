import KituraNet
import Foundation

public final class Static: KirHandler {

	let directory: String
	let prefixString: String?
	let indexFile: String

	public init(directory dir: String, prefixString pre: String? = nil, indexFile index: String = "index.html") {
		directory = dir
		prefixString = pre
		indexFile = index
	}


	public func handle(request: ServerRequest, response: ServerResponse, next: HTTPServerDelegate?) {
		 guard request.method == "GET" || request.method == "HEAD" else {
            if let n = next {
            	n.handle(request: request, response: response)
            }
            return
        }

        var file = request.urlString
        
        if let pre = prefixString {

        	if !file.hasPrefix(pre)  {
        		if let n = next {
            		n.handle(request: request, response: response)
            	}
            	return 			
        	}

        	file = file[pre.endIndex..<file.endIndex]

        	if file != "" && file[file.startIndex] != "/" {
			if let n = next {
            		n.handle(request: request, response: response)
            	}
			return
		}

        } 

        // Serve found file
        let fileManager = NSFileManager()
        var isDirectory = ObjCBool(false)

        if fileManager.fileExists(atPath: file, isDirectory: &isDirectory) {
                if !isDirectory.boolValue {
                    serveFile(file, fileManager: fileManager, response: response)
                }
        }   
	}

	  private func serveFile(_ filePath: String, fileManager: NSFileManager, response: ServerResponse) {
        // Check that no-one is using ..'s in the path to poke around the filesystem
        let tempAbsoluteBasePath = NSURL(fileURLWithPath: directory).absoluteString
        let tempAbsoluteFilePath = NSURL(fileURLWithPath: filePath).absoluteString
        let absoluteBasePath = tempAbsoluteBasePath
        let absoluteFilePath = tempAbsoluteFilePath

        if  absoluteFilePath.hasPrefix(absoluteBasePath) {
            do {
            	let data = NSData(contentsOfFile: filePath)!
                try response.write(from: data)
            } catch {
                // Nothing
            }
            response.statusCode = .OK
        }
    }
}

