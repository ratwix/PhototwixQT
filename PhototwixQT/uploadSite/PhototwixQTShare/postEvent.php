<?php
	include_once 'connect.php';

	$event_code = mysqli_real_escape_string(GetMyConnection(), $_POST['event_code']);
	$event_title = mysqli_real_escape_string(GetMyConnection(), $_POST['event_name']);
	$event_facebook_text = mysqli_real_escape_string(GetMyConnection(), $_POST['event_facebook_text']);
	$event_twitter_text = mysqli_real_escape_string(GetMyConnection(), $_POST['event_twitter_text']);
	$event_google_text = mysqli_real_escape_string(GetMyConnection(), $_POST['event_google_text']);
	
	$event_mail_subject = mysqli_real_escape_string(GetMyConnection(), $_POST['event_mail_subject']);
	$event_mail_from = mysqli_real_escape_string(GetMyConnection(), $_POST['event_mail_from']);
	$event_mail_cc = mysqli_real_escape_string(GetMyConnection(), $_POST['event_mail_cc']);
	$event_mail_text = mysqli_real_escape_string(GetMyConnection(), $_POST['event_mail_text']);
	
	$query = "INSERT INTO events (
					event_code, 
					event_name, 
					event_facebook_text, 
					event_twitter_text, 
					event_google_text, 
					event_mail_subject, 
					event_mail_from, 
					event_mail_cc, 
					event_mail_text) VALUES (
					'$event_code', 
					'$event_title', 
					'$event_facebook_text', 
					'$event_twitter_text', 
					'$event_google_text', 
					'$event_mail_subject', 
					'$event_mail_from', 
					'$event_mail_cc', 
					'$event_mail_text') ON DUPLICATE KEY UPDATE
					event_name='$event_title',
					event_facebook_text='$event_facebook_text', 
					event_twitter_text='$event_twitter_text', 
					event_google_text='$event_google_text', 
					event_mail_subject='$event_mail_subject', 
					event_mail_from='$event_mail_from', 
					event_mail_cc='$event_mail_cc', 
					event_mail_text='$event_mail_text'";
					
	$res = mysqli_query(GetMyConnection(), $query);
?>