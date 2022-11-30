import sysnetif
import Logging

struct NetInterfaceKit {
	static var logger = Logger(label:"NetInterfaceKit")
	
	enum Error:Swift.Error {
		case noInterfacesFound
	}
	
	struct NetworkInterface:Hashable {
		let index:UInt32
		let name:String
	}
	
	static func allInterfaces() throws -> Set<NetworkInterface> {
		guard let getNameArray = if_nameindex() else {
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
			buildResults.update(with:NetworkInterface(index:i.pointee.if_index, name:nameString))
			i = i.advanced(by:1)
		}
		return buildResults
	}
}