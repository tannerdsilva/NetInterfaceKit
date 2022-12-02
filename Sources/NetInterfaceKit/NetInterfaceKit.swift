import Logging
import sysincludes

public struct NetInterfaceKit {
	public static var logger = Logger(label:"net-interface-kit")
	
	public enum Error:Swift.Error {
		case noInterfacesFound
		case socketOpenError
		case ioctlError
	}
		
	struct NetworkInterface:Hashable {
		let name:String
		let index:UInt32
		let macAddress:String
		let flags:InterfaceFlags
	}
	
	static func allInterfaces() throws -> Set<NetworkInterface> {
		// list the name of interfaces
		guard let getNameArray = if_nameindex() else {
			Self.logger.error("allInterfaces() called but no network interfaces found")
			throw Error.noInterfacesFound
		}
		defer {
			if_freenameindex(getNameArray)
		}
		
		var i = getNameArray;
		var buildResults = Set<NetworkInterface>()
		
		let socketfd = socket(AF_INET, Int32(SOCK_STREAM.rawValue), Int32(IPPROTO_IP))
		guard socketfd != -1 else {
			Self.logger.error("allInterfaces() called but unable to open INET socket")
			throw Error.socketOpenError
		}
		defer {
			close(socketfd)
		}
		
		var interfaceRequestItem = ifreq()
		while (i.pointee.if_index != 0 && i.pointee.if_name != nil) {
			strcpy(&interfaceRequestItem.ifr_ifrn.ifrn_name, i.pointee.if_name);
			let nameString = String(cString:i.pointee.if_name)
			
			guard ioctlCall(socketfd, SIOCGIFHWADDR, &interfaceRequestItem) != -1 else {
				throw Error.ioctlError
			}
			
			var macStr = macstr_t()
			getHWAddr(&interfaceRequestItem, &macStr);
			let macString = String(cString:macstrToCstr(&macStr));
			Self.logger.trace("found new interface", metadata:["name":"\(nameString)", "mac":"\(macString)"])
			buildResults.update(with:NetworkInterface(name:nameString, index:i.pointee.if_index, macAddress:macString, flags:InterfaceFlags(rawValue:interfaceRequestItem.ifr_flags)))
			i = i.advanced(by:1)
		}
		
		return buildResults
	}
}

