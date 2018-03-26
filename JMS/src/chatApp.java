import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/chat")
class chatAppServer {
    private static final String USERNAME_KEY = "username";
    private static Map<String, Session> chatRooms= Collections.synchronizedMap(new LinkedHashMap<String,Session>());


    @OnOpen
    public void onOpen(Session session) throws Exception {


        Map<String, List<String>> parameter = session.getRequestParameterMap();
        List<String> list = parameter.get(USERNAME_KEY);
        String newUsername = list.get(0);

        //Add the new socket to the collection
        chatRooms.put(newUsername, session);


        session.getUserProperties().put(USERNAME_KEY, newUsername);


        String response = "newUser|" + String.join("|", chatRooms.keySet());
        session.getBasicRemote().sendText(response);

        //Loop through all socket's session obj, then send a text message
        for (Session client : chatRooms.values()) {
            if(client == session) continue;
            client.getBasicRemote().sendText("newUser|" + newUsername);
        }
    }

    @OnMessage
    public void onMessage(Session session, String message) throws Exception {
        //
        String[] data = message.split("\\|");
        String destination = data[0];
        String messageContent = data[1];

        //Retrieve the sender's username from it's property
        String sender = (String)session.getUserProperties().get(USERNAME_KEY);


        if(destination.equals("all")) {
            //if the destination chat is 'all', then we broadcast the message
            for (Session client : chatRooms.values()) {
                if(client.equals(session)) continue;
                client.getBasicRemote().sendText("message|" + sender + "|" + messageContent + "|all" );
            }
        } else {
            //find the username to be sent, then deliver the message
            Session client = chatRooms.get(destination);
            String response = "message|" + sender + "|" + messageContent;
            client.getBasicRemote().sendText(response);
        }
    }

    @OnClose
    public void onClose(Session session) throws Exception {
        //remove client from collecton
        String username = (String)session.getUserProperties().get(USERNAME_KEY);
        chatRooms.remove(username);

        //broadcast to all people, that the current user is leaving the chat room
        for (Session client : chatRooms.values()) {
            client.getBasicRemote().sendText("removeUser|" + username);
        }
    }
}
