/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example;


import javax.annotation.Resource;
import javax.inject.Named;
import javax.enterprise.context.RequestScoped;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.inject.Inject;
import javax.jms.JMSConnectionFactory;
import javax.jms.JMSContext;
import javax.jms.JMSRuntimeException;
import javax.jms.Queue;

/**
 *
 * @author sid
 */
@Named(value = "senderBean")
@RequestScoped
public class SenderBean {
    @Resource(mappedName="jms/myQueue")
    private Queue myQueue;
    @Inject
    @JMSConnectionFactory("java:comp/DefaultJMSConnectionFactory")
    private JMSContext context;
    private String messageText;

    /**
     * Creates a new instance of SenderBean
     */
    public SenderBean() {
    }
    
    public String getMessageText() {
        return messageText;
    }

    public void setMessageText(String messageText) {
        this.messageText = messageText;
    }
    public void sendJMSMessageToQueue() {
         try {
            String text = "Message from producer: " + messageText;
            context.createProducer().send(myQueue, text);
 
            FacesMessage facesMessage =
                    new FacesMessage("Sent message: " + text);
            FacesContext.getCurrentInstance().addMessage(null, facesMessage);
        } catch (JMSRuntimeException t) {
             System.out.println(t.toString());
        }
    }
}
