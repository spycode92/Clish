package com.itwillbs.clish.common.emailAuth;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class EmailClient {

    @Value("${mail.host}")
    private String host;

    @Value("${mail.port}")
    private String port;

    @Value("${mail.username}")
    private String username;

    @Value("${mail.app_password}")
    private String password;

    @Value("${mail.sender.name}")
    private String senderName;
    
    
    public void sendMail(String toEmail, String subject, String htmlContent) {

    	try {
            
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username, senderName, "UTF-8"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            new Thread(() -> {
                try {
                    Transport.send(message);
                    System.out.println("메일 발송 완료 → " + toEmail);
                } catch (MessagingException e) {
                    System.err.println("메일 전송 실패");
                    e.printStackTrace();
                }
            }).start();

        } catch (MessagingException | UnsupportedEncodingException e) {
            System.err.println("메일 설정 오류");
            e.printStackTrace();
        }
    }
}