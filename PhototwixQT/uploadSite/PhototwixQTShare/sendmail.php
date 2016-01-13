<?php
require "PHPMailer/PHPMailerAutoload.php";

$mail = new PHPMailer;

$mail->isSMTP();                         // Set mailer to use SMTP
$mail->Host = 'smtp-fr.securemail.pro';  // Specify main and backup SMTP servers
$mail->SMTPAuth = true;                  // Enable SMTP authentication
$mail->Username = 'test@phototwix.fr';   // SMTP username
$mail->Password = 'phototwix123';        // SMTP password
$mail->SMTPSecure = 'tls';               // Enable TLS encryption, `ssl` also accepted
$mail->Port = 465;                       // TCP port to connect to

$mail->setFrom('charles@phototwix.fr', 'Mailer');
$mail->addAddress('charles.rathouis@gmail.com');     // Add a recipient
$mail->addReplyTo('contact@phototwix.fr', 'Information');

$mail->addAttachment('photos/test.png');
$mail->isHTML(true);

$mail->Subject = 'Photo du photomaton';
$mail->Body    = 'Ceci est un test';
$mail->AltBody = 'Votre photo';

if(!$mail->send()) {
    echo 'Message could not be sent.';
    echo 'Mailer Error: ' . $mail->ErrorInfo;
} else {
    echo 'Message has been sent';
}

?>