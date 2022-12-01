import sysnetif
import Logging

struct NetInterfaceKit {
	static var logger = Logger(label:"NetInterfaceKit")
	
	enum Error:Swift.Error {
		case noInterfacesFound
	}
	
	struct InterfaceNameIndex:Hashable {
		let name:String
		let index:UInt32
	}
	
	static func allInterfaces() throws -> Set<InterfaceNameIndex> {
		guard let getNameArray = if_nameindex() else {
			Self.logger.error("allInterfaces() called but no network interfaces found")
			throw Error.noInterfacesFound
		}
		defer {
			if_freenameindex(getNameArray)
		}
		var i = getNameArray;
		var buildResults = Set<InterfaceNameIndex>()
		while (i.pointee.if_index != 0 && i.pointee.if_name != nil) {
			let nameString = String(cString:i.pointee.if_name)
			Self.logger.info("found new interface", metadata:["name":"\(nameString)"])
			buildResults.update(with:InterfaceNameIndex(name:nameString, index:i.pointee.if_index))
			i = i.advanced(by:1)
		}
		return buildResults
	}
}