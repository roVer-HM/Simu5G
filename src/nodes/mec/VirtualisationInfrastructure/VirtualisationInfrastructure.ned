//
//                  Simu5G
//
// Authors: Giovanni Nardini, Giovanni Stea, Antonio Virdis (University of Pisa)
//
// This file is part of a software released under the license included in file
// "license.pdf". Please read LICENSE and README files before using it.
// The above files and the present reference are part of the software itself,
// and cannot be removed from it.
//

package simu5g.nodes.mec.VirtualisationInfrastructure;

import inet.linklayer.ppp.PppInterface;
import inet.linklayer.ethernet.contract.IEthernetLayer;
import inet.linklayer.ieee8021q.IIeee8021qLayer;
import inet.linklayer.ieee8021r.IIeee8021rLayer;
import inet.linklayer.ieee8022.IIeee8022Llc;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.ipv4.Ipv4RoutingTable;
import inet.networklayer.contract.IRoutingTable;
import inet.networklayer.contract.INetworkLayer;
import inet.applications.contract.IApp;
import inet.transportlayer.udp.Udp;
import inet.transportlayer.tcp.Tcp;
import inet.protocolelement.contract.IProtocolLayer;

import inet.common.MessageDispatcher;
import simu5g.nodes.mec.VirtualisationInfrastructure.VirtualisationManager;

import inet.linklayer.contract.IEthernetInterface;


// 
//# VirtualisationInfrastructure
//

module VirtualisationInfrastructure
{
    parameters:
        @networkNode();
        @display("bgb=1343.3201,1123.16;i=block/dispatch");
        @figure[applicationLayer](type=rectangle; pos=250,6; size=600,130; lineColor=#808080; cornerRadius=5; fillColor=#ffff00; fillOpacity=0.1);
        @figure[applicationLayer.title](type=text; pos=845,11; anchor=ne; text="application layer");
        @figure[transportLayer](type=rectangle; pos=250,156; size=600,130; fillColor=#ff0000; lineColor=#808080; cornerRadius=5; fillOpacity=0.1);
        @figure[transportLayer.title](type=text; pos=845,161; anchor=ne; text="transport layer");
        @figure[networkLayer](type=rectangle; pos=250,306; size=600,130; fillColor=#00ff00; lineColor=#808080; cornerRadius=5; fillOpacity=0.1);
        @figure[networkLayer.title](type=text; pos=845,311; anchor=ne; text="network layer");
        @figure[linkLayer](type=rectangle; pos=250,456; size=600,130; fillColor=#0000ff; lineColor=#808080; cornerRadius=5; fillOpacity=0.1);
        @figure[linkLayer.title](type=text; pos=845,461; anchor=ne; text="link layer");
        @figure[interfaceLayer](type=rectangle; pos=250,600; size=600,130; fillColor=#00ffff; lineColor=#808080; cornerRadius=5; fillOpacity=0.1);
        @figure[interfaceLayer.title](type=text; pos=845,605; anchor=ne; text="interface layer");
        @figure[submodules];

        //# Network Layer specs
        bool hasIpv4 = default(true);
        bool hasIpv6 = default(false);
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.routingTableModule = default("^.ipv4.routingTable");

        int numBGMecApp = default(0);
        int numExtEthInterfaces = default(0);
        
        ethernet.registerProtocol = default(true);

    gates:

        inout ppp[];				// connection with GtpEndpoint and local/externa networks

        output meBGAppOut[numBGMecApp];			// connection to the ME App input gate
        input meBGAppIn[numBGMecApp];			// connection to the ME App output gate

        output meAppOut[];			// connection to the ME App input gate
        input meAppIn[];			// connection to the ME App output gate

        inout mePlatform;			// connection to the ME Platform

    submodules:

        interfaceTable: InterfaceTable {
            @display("p=61.344,74.976;is=s");
        }
        ethernet: <default("EthernetEncapsulation")> like IEthernetLayer if typename != "" {
            @display("p=419.68002,519.44");
        }
        li: MessageDispatcher {
            @display("p=550,596.84;b=600,5,,,,1");
        }

        //#
        //# ppp modules
        //#
        pppIf[sizeof(ppp)]: PppInterface {
            @display("p=780.88,686.28");
        }

   	  	//# ethernet interface used for communicating with the MEC service in the MEC platform
        eth: <default("EthernetInterface")> like IEthernetInterface {
            parameters:
                @display("p=548.68,686.28,row,150;q=txQueue");
        }

        //# ethernet interface used for communicating with external applications in emulation mode
        extEth[numExtEthInterfaces]: <default("ExtLowerEthernetInterface")> like IEthernetInterface {
            parameters:
                @display("p=283.80002,686.28,row,150;q=txQueue");
        }


        //#
        //# Network layer module
        //#
        ipv4: <default("Ipv4NetworkLayer")> like INetworkLayer if hasIpv4 {
            parameters:
                @display("p=420.28,372.88;q=queue");
        }
        ipv6: <default("Ipv6NetworkLayer")> like INetworkLayer if hasIpv6 {
            parameters:
                @display("p=657.28,374.46;q=queue");
        }

        //#
        //# Transport layer modules and corresponding application modules
        //#
		// =============== UDP ============== //
//        virtualisationManager: VirtualisationManager {
//            @display("p=657,74,row");
//        }

        udp: Udp {
            @display("p=459,217");
        }

        tcp: Tcp {
            @display("p=627,217");
        }

        // message dispatcher for SAP between application and transport layer
        at: MessageDispatcher {
            parameters:
                @display("p=550,146;b=600,5,,,,1");
        }
        // message dispatcher for SAP between transport and network layer
        tn: MessageDispatcher {
            parameters:
                @display("p=550,296;b=600,5,,,,1");
        }
        // message dispatcher for SAP to link layer
        nl: MessageDispatcher {
            parameters:
                @display("p=550,446;b=600,5,,,,1");
        }

    connections allowunconnected:


        for i=0..numBGMecApp-1 {
            at.out++ --> meBGAppOut++;
            at.in++ <-- meBGAppIn++;
        }

        //# 
        //# VirtualisationManager to transport layer connections
        //#        
//        virtualisationManager.socketOut --> at.in++;
//        virtualisationManager.socketIn <-- at.out++;

        at.out++ --> udp.appIn;
        at.in++ <-- udp.appOut;

        at.out++ --> tcp.appIn;
        at.in++ <-- tcp.appOut;


        //# 
        //# Transport layer to network layer connections
        //#
        udp.ipOut --> tn.in++;
        udp.ipIn <-- tn.out++;

        tcp.ipOut --> tn.in++;
        tcp.ipIn <-- tn.out++;


        ipv4.ifIn <-- nl.out++ if hasIpv4;
        ipv4.ifOut --> nl.in++ if hasIpv4;

        ipv4.transportIn <-- tn.out++ if hasIpv4;
        ipv4.transportOut --> tn.in++ if hasIpv4;

        ipv6.ifIn <-- nl.out++ if hasIpv6;
        ipv6.ifOut --> nl.in++ if hasIpv6;

        ipv6.transportIn <-- tn.out++ if hasIpv6;
        ipv6.transportOut --> tn.in++ if hasIpv6;

        li.out++ --> nl.in++;
        li.in++ <-- nl.out++;

        nl.out++ --> ethernet.upperLayerIn if exists(ethernet);
        ethernet.upperLayerOut --> nl.in++ if exists(ethernet);

        ethernet.lowerLayerOut --> li.in++ if exists(ethernet);
        li.out++ --> ethernet.lowerLayerIn if exists(ethernet);

        for i=0..sizeof(ppp)-1 {
            pppIf[i].upperLayerOut --> li.in++;
            pppIf[i].upperLayerIn <-- li.out++;
            pppIf[i].phys <--> ppp++;
        }

        for i=0..numExtEthInterfaces-1 {
            extEth[i].upperLayerOut --> li.in++;
            extEth[i].upperLayerIn <-- li.out++;
        }

        eth.upperLayerOut --> li.in++;
        eth.upperLayerIn <-- li.out++;
        eth.phys <--> mePlatform;

}
