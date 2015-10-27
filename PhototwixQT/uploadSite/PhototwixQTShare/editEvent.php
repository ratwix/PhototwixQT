<?php
	include_once 'connect.php';

	$event = "";
	
	if (isset($_GET["event_code"])) {
		$event = $_GET["event_code"];
	}
	
	$event_code = $event;
	$event_title = "";
	$event_facebook_text = "";
	$event_twitter_text = "";
	$event_google_text = "";
	
	$event_mail_subject = "";
	$event_mail_from = "";
	$event_mail_cc = "";
	$event_mail_text = "";
	
	if ($event != "") {
		$query = "SELECT event_code, 
						event_name, 
						event_facebook_text, 
						event_twitter_text, 
						event_google_text, 
						event_mail_subject, 
						event_mail_from, 
						event_mail_cc, 
						event_mail_text FROM events WHERE event_code = '$event_code'";
	
		$res = mysqli_query(GetMyConnection(), $query);
		$events = mysqli_fetch_assoc($res);
		
		$event_title = $events['event_name'];
		$event_facebook_text = $events['event_facebook_text'];
		$event_twitter_text = $events['event_twitter_text'];
		$event_google_text = $events['event_google_text'];
		
		$event_mail_subject = $events['event_mail_subject'];
		$event_mail_from = $events['event_mail_from'];
		$event_mail_cc = $events['event_mail_cc'];
		$event_mail_text = $events['event_mail_text'];
	}
	
	echo "<form id=\"edit_event_form\">";

	if ($event != "") {
		echo "<h1>Evenement : $event_title</h1>";
	} else {
		echo "<h1>Nouvel evenement</h1>";
	}
	
	echo "<p>";
		echo "<label>";
			echo "<span>Code evenement :</span>";
			if ($event == "") {
				echo "<input id=\"event_code\" type=\"text\" name=\"event_code\" placeholder=\"Code a entrer dans la machine\"></input>";
			} else {
				echo "<input id=\"event_code\" type=\"text\" name=\"event_code\" value=\"$event_code\" disabled=\"disabled\"></input>";
			}
		echo "</label>";
		
		echo "<label><span>Titre :</span><input id=\"event_title\" type=\"text\" name=\"event_title\" value=\"$event_title\"></input></label>";
		echo "<label><span>Texte Facebook :</span><input id=\"event_facebook_text\" type=\"text\" name=\"event_facebook_text\" value=\"$event_facebook_text\"></input></label>";
		echo "<label><span>Texte Twitter :</span><input id=\"event_twitter_text\" type=\"text\" name=\"event_twitter_text\" value=\"$event_twitter_text\"></input></label>";
		echo "<label><span>Texte Google+ :</span><input id=\"event_google_text\" type=\"text\" name=\"event_google_text\" value=\"$event_google_text\"></input></label>";
	echo "</p>";
	echo "<p>";
		echo "<label><span>Mail sujet :</span><input id=\"event_mail_subject\" type=\"text\" name=\"event_mail_subject\" value=\"$event_mail_subject\"></input></label>";
		echo "<label><span>Mail from :</span><input id=\"event_mail_from\" type=\"text\" name=\"event_mail_from\" value=\"$event_mail_from\"></input></label>";
		echo "<label><span>Mail cc :</span><input id=\"event_mail_cc\" type=\"text\" name=\"event_mail_cc\" value=\"$event_mail_cc\"></input></label>";
		echo "<label><span>Mail text :</span><textarea id=\"event_mail_text\" name=\"event_mail_text\" rows=8>$event_mail_text</textarea></label>";
	echo "</p>";
	
	if ($event == "") {
		echo "<input type=\"button\" class=\"button\" value=\"Créer\" onclick=\"postEvent()\">";
	} else {
		echo "<input type=\"button\" class=\"button\" value=\"Modifier\" onclick=\"postEvent()\">";
	}
?>