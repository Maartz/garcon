const std = @import("std");
const net = std.net;
const StreamServer = net.StreamServer;
const Address = net.Address;

pub fn main() anyerror!void {
    const stream_server = StreamServer.init(.{});
    defer stream_server.close();

    const address = try Address.resolveIp("127.0.0.1", 7777);
    stream_server.listen(address);
}
