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
//		let flags:InterfaceFlags
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
			
			var newString = malloc(32);
			let getAddr = interfaceRequestItem.ifr_ifru.ifru_hwaddr.sa_data
			snprintf(newString, 32, "%02x:%02x:%02x:%02x:%02x:%02x", getAddr.0, getAddr.1, getAddr.2, getAddr.3, getAddr.4, getAddr.5)
			defer {
				free(newString);
			}
			let macString = String(cString:newString);
			Self.logger.trace("found new interface", metadata:["name":"\(nameString)", "mac":"\(macString)"])
			buildResults.update(with:NetworkInterface(name:nameString, index:i.pointee.if_index, macAddress:macString))
			i = i.advanced(by:1)
		}
		
		return buildResults
	}
}

