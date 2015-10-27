<?php
	include_once 'connect.php';

	$query = "SELECT event_code, event_name FROM events";
	
	$res = mysqli_query(GetMyConnection(), $query);
	
	echo '<ul>';
	
	while($events = mysqli_fetch_assoc($res)) {
		$event_code = $events['event_code'];
		$event_title = $events['event_name'];
		
		echo '<li class="blue">';
			echo "<div onclick=\"loadEdit('$event_code')\">
					<label>$event_title ($event_code)</label>
					<a id=\"download\" href=\"#\" onclick=\"downloadEvent('$event_code')\"></a>
				  </div>";
		echo '</li>';
	}
	echo "</ul>";
?>