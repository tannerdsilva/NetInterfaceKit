import Logging
import sysincludes

public struct NetInterfaceKit {
	public static var logger = Logger(label:"NetInterfaceKit")
	
	public enum Error:Swift.Error {
		case noInterfacesFound
		case socketOpenError
	}
		
	struct NetworkInterface:Hashable {
		let name:String
		let index:UInt32
//		let macAddress:String
//		let flags:InterfaceFlags
	}
	
	static func allInterfaces() throws -> Set<NetworkInterface> {
		guard let getNameArray = if_nameindex() else {
			Self.logger.error("allInterfaces() called but no network interfaces found")
			throw Error.noInterfacesFound
		}
		defer {
			if_freenameindex(getNameArray)
		}
		var i = getNameArray;
		var buildResults = Set<NetworkInterface>()
		while (i.pointee.if_index != 0 && i.pointee.if_name != nil) {
			let nameString = String(cString:i.pointee.if_name)
			Self.logger.info("found new interface", metadata:["name":"\(nameString)"])
			buildResults.update(with:NetworkInterface(name:nameString, index:i.pointee.if_index))
			i = i.advanced(by:1)
		}
		return buildResults
	}
}

