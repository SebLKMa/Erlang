package demo.erlang.client;

import com.ericsson.otp.erlang.*; // For the JInterface package

public class helloErlang {

	static String client = "java";
    static String server = "bar@LMA02";
    static String global = "myServerName";
    
    public static void doSendByOtpConnection() throws Exception {
    	OtpErlangLong number = new OtpErlangLong(6);
    	OtpSelf clientSelf = new OtpSelf(client/*, no cookie*/);
        clientSelf.publishPort();
        
        OtpPeer peer = new OtpPeer(server);
        OtpConnection conn = clientSelf.connect(peer);
        System.out.println(clientSelf.node() + " connection:" + conn.isAlive());        
        
        OtpErlangObject msg = new OtpErlangTuple(
                new OtpErlangObject[] {
                		clientSelf.pid(), 
                		number});
        conn.send(server, msg);
                    
        System.out.println("message sent, waiting for reply...");
        while (true) {
        	try {
                OtpErlangObject reply = conn.receive(3000);                
                if (reply != null) {
                	System.out.println("Received " + reply);
                }        
        		break;
        	} catch (InterruptedException e) {
        		System.out.println(e);
        		break; 
        	} catch (OtpErlangExit e) { 
        		break; 
        	}
        }
        
        conn.close();        
        //System.out.println(clientSelf.node() + " connection:" + conn.isAlive());
    }
    
    public static void doSendByOtpMbox () throws Exception {
    	OtpErlangObject msg = new OtpErlangLong(8);
        OtpNode node = new OtpNode(client);
        OtpMbox mbox = node.createMbox("java_client");        
        if (!node.ping(server, 2000)) {
        	System.out.println(server + " ping failed!");
        	System.exit(1);
        }
        System.out.println(server + " ping success.");


        mbox.send("facserver", server, new OtpErlangTuple(
                new OtpErlangObject[] {
                        mbox.self (), msg}));
        
        System.out.println("message sent, waiting for reply...");
        while (true) {
        	try {
                OtpErlangObject reply = mbox.receive(3000);
                
                if (reply != null) {
                	System.out.println("Received " + reply);
                }        
        		break;
        	} catch (OtpErlangExit e) { 
        		break; 
        	}
        }
        mbox.close();
    }

    public static void main(String[] args) throws Exception {
    	doSendByOtpConnection();
    	//doSendByOtpMbox();
    }
}
