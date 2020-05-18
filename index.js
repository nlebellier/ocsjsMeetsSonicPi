var osc = require("osc");


/****************
 * OSC Over UDP *
 ****************/

var getIPAddresses = function () {
    var os = require("os"),
        interfaces = os.networkInterfaces(),
        ipAddresses = [];

    for (var deviceName in interfaces) {
        var addresses = interfaces[deviceName];
        for (var i = 0; i < addresses.length; i++) {
            var addressInfo = addresses[i];
            if (addressInfo.family === "IPv4" && !addressInfo.internal) {
                ipAddresses.push(addressInfo.address);
            }
        }
    }

    return ipAddresses;
};

var udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: 4560,

	// Important : indicates the incoming port displayed into sonic pi ! here 51240
    remoteAddress: "127.0.0.1",
    remotePort: 51240,
    metadata: true
	
});

udpPort.on("ready", function () {
    var ipAddresses = getIPAddresses();
    console.log("Listening for OSC over UDP.");
    ipAddresses.forEach(function (address) {
        console.log(" Host:", address + ", Port:", udpPort.options.localPort);
    });
});

udpPort.on("message", function (oscMessage) {
    console.log(oscMessage);
});

udpPort.on("error", function (err) {
    console.log(err);
});

udpPort.open();


/*********** send to sonic pi *****/
// Every second, send an OSC message to Sonic Pi - 1000 ms = 1s :-)
setInterval(function() {
    var msg = {
        address: "/play/note",
        args: [
            {
 		    // midi note value 
		        type: "i",
                value: 60+24
            },
            {   // amp value a float to send decimal numbers
                type: "f",
                value: 1.5
            },
	        {   // sustain value
		        type: "f",
		        value: 2
		    }
        ]
    };

    console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
    udpPort.send(msg);
}, 1000);