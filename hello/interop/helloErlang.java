package demo.erlang.client;

import com.ericsson.otp.erlang.*; // For the JInterface package
import java.math.BigInteger; // For factorial calculations

public class helloErlang {
	/*
	public static void main (String[] args) throws Exception {
		OtpNode java = new OtpNode("java");
		OtpMbox mbox = j.createMbox("facclient");
		mbox.send(mbox.self(), 6);
	}
	*/
	static String client = "java";
    static String server = "bar@LMA02";
    static String global = "myServerName";

    public static void main(String[] args) throws Exception {
    	OtpErlangObject msg = new OtpErlangLong(8);
    	//OtpSelf clientSelf = new OtpSelf(client/*, no cookie*/);
        //clientSelf.publishPort();
        /*
        OtpPeer peer = new OtpPeer(server);
        OtpConnection conn = clientSelf.connect(peer);
        System.out.println(clientSelf.node() + " connection:" + conn.isAlive());        
        
        conn.send(clientSelf.pid(), msg);
        */
        OtpNode node = new OtpNode(client);
        OtpMbox mbox = node.createMbox("java_client");        
        if (!node.ping(server, 2000)) {
        	System.out.println(server + " ping failed!");
        	System.exit(1);
        }
        System.out.println(server + " ping success.");
        //mbox.send("facserver", server, msg);

        mbox.send("facserver", server, new OtpErlangTuple(
                new OtpErlangObject[] {
                        mbox.self(), msg}));
        
        System.out.println("message sent, waiting for reply...");
        while (true) {
        	try {
                //OtpErlangObject reply = conn.receive(3000);
                OtpErlangObject reply = mbox.receive(3000);
                
                if (reply != null) {
                	System.out.println("Received " + reply);
                }        
        		break;
        	//} catch (InterruptedException e) { 
        	//	break; 
        	} catch (OtpErlangExit e) { 
        		break; 
        	}
        }
        mbox.close();
        //conn.close();        
        //System.out.println(clientSelf.node() + " connection:" + conn.isAlive());

    }
}
