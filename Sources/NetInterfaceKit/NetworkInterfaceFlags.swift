import sysincludes

extension NetInterfaceKit {
	public struct InterfaceFlags:Hashable, OptionSet {
		public let rawValue:Int16
		
		public init(rawValue:Int16) {
			self.rawValue = rawValue
		}
		
		public static let up = InterfaceFlags(rawValue:Int16(IFF_UP))
		public static let broadcast = InterfaceFlags(rawValue:Int16(IFF_BROADCAST))
		public static let debug = InterfaceFlags(rawValue:Int16(IFF_DEBUG))
		public static let loopback = InterfaceFlags(rawValue:Int16(IFF_LOOPBACK))
		public static let pointToPoint = InterfaceFlags(rawValue:Int16(IFF_POINTOPOINT))
		public static let running = InterfaceFlags(rawValue:Int16(IFF_RUNNING))
		public static let noArp = InterfaceFlags(rawValue:Int16(IFF_NOARP))
		public static let promiscuous = InterfaceFlags(rawValue:Int16(IFF_PROMISC))
		public static let noTrailers = InterfaceFlags(rawValue:Int16(IFF_NOTRAILERS))
		public static let allMulticast = InterfaceFlags(rawValue:Int16(IFF_ALLMULTI))
		public static let master = InterfaceFlags(rawValue:Int16(IFF_MASTER))
		public static let slave = InterfaceFlags(rawValue:Int16(IFF_SLAVE))
		public static let multicast = InterfaceFlags(rawValue:Int16(IFF_MULTICAST))
		public static let portsel = InterfaceFlags(rawValue:Int16(IFF_PORTSEL))
		public static let autoMedia = InterfaceFlags(rawValue:Int16(IFF_AUTOMEDIA))
		public static let dynamic = InterfaceFlags(rawValue:Int16(IFF_DYNAMIC))
	}
}