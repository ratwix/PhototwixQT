

<html>
	<head>
		<meta charset="utf-8" />
        <title>Phototwix</title>
		<script src="./lib/oauth.min.js"></script>
		<link rel="stylesheet" type="text/css" href="css/mainstyle.css">
		
		<script>
			
			
			var callback_res = "<?php if (isset($_GET['callback'])) { echo $_GET['callback']; } else { echo '';} ?>"

<?php
			$imagePath = "";
			$event_code = "";

			function cut_string_using_last($character, $string, $side, $keep_character=true) { 
				$offset = ($keep_character ? 1 : 0); 
				$whole_length = strlen($string); 
				$right_length = (strlen(strrchr($string, $character)) - 1); 
				$left_length = ($whole_length - $right_length - 1); 
				switch($side) { 
					case 'left': 
						$piece = substr($string, 0, ($left_length + $offset)); 
						break; 
					case 'right': 
						$start = (0 - ($right_length + $offset)); 
						$piece = substr($string, $start); 
						break; 
					default: 
						$piece = false; 
						break; 
				} 
				return($piece); 
			} 


			if(isset($_GET['filename'])) {
				$imagePath = urldecode($_GET['filename']);
			} else {
				echo "No filename";
			}

			if(isset($_GET['event_code'])) {
				$event_code = urldecode($_GET['event_code']);
			} else {
				echo "No event";
			}

			$actual_link_base =  "http://" . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'];

			$actual_link = cut_string_using_last('/', $actual_link_base, 'left', true);
			$actual_link = $actual_link."photos/".$imagePath;
			$actual_link_encode = urlencode($actual_link);

?>			
			
			
			var picUrl = encodeURIComponent("<?php echo $actual_link;?>")
			var redirectUrl = encodeURIComponent("<?php echo $actual_link_base; ?>")
			
			function postFacebook() {
				OAuth.redirect('facebook', {cache: true}, "<?php echo $actual_link_base."&callback=facebook"; ?>");	
			}
			
			function postTwitter() {
				OAuth.redirect('twitter', {cache: true}, "<?php echo $actual_link_base."&callback=twitter"; ?>");					
			}			
			
			
			function postInstagram() {
				OAuth.redirect('instagram', {cache: true}, "<?php echo $actual_link_base."&callback=instagram"; ?>");						
			}

			function postGooglePlus() {
				OAuth.clearCache();
				OAuth.redirect('google_plus', {cache: false}, "<?php echo $actual_link_base."&callback=google_plus"; ?>");
			}
			
			function postEmail() {
				
			}
			
			
			OAuth.initialize('3P-A917vxAg-qsXtHy4MtGjiH2Q');

			if ("" == callback_res) {
				OAuth.clearCache();
			}	
			
			if ("google_plus" == callback_res) {
				OAuth.callback('google_plus', {cache: false})
					.done(function(result) {
					  console.log("Tachatte");
					  result.me()
						.done(function (response) {
							console.log('/me response: ' + JSON.stringify(response));
						})
						.fail(function (err) {
							console.log('/me error: ' + JSON.stringify(err));
						})
					})
					.fail(function (error) {
							console.log('Error connect google_plus:' + JSON.stringify(error));
					});
			}
			
			if ("instagram" == callback_res) {
				OAuth.callback('instagram')
					.done(function(result) {
					  result.me()
						.done(function (response) {
							console.log('/me response: ' + JSON.stringify(response));
						})
						.fail(function (err) {
							console.log('/me error: ' + JSON.stringify(err));
						})
					})
					.fail(function (error) {
							console.log('Error connect instagram' + JSON.stringify(error));
					});
			}
			
			if ("twitter" == callback_res) {
				OAuth.callback('twitter')
					.done(function(result) {
					  result.get('/1.1/account/verify_credentials.json')
						.done(function (response) {
							console.log('/me response: ' + JSON.stringify(response));
						})
						.fail(function (err) {
							console.log('/me error: ' + JSON.stringify(err));
						})
					})
					.fail(function (error) {
							console.log('Error connect twitter	' + JSON.stringify(error));
					});
			}
			
			if ("facebook" == callback_res) {
				OAuth.callback('facebook')
					.done(function(result) {
					  result.get('/me?fields=name,email,gender,birthday,hometown,interested_in,languages,last_name,cover')
						.done(function (response) {
							console.log('/me response: ' + JSON.stringify(response));
						})
						.fail(function (err) {
							console.log('/me error: ' + JSON.stringify(err));
						});
						
					  result.get('/me/permissions')
					  .done(function (response) {
							console.log('/me/permissions: ' + JSON.stringify(response));
						})
					/*	
					  result.post('/me/feed', {
							data: {
								message: 'Phototwix test!',
								link: "http://www.vargajeanclaude.be/medias/images/iamnotanartist-gifparanoia-08.gif"
							}
						})
						.done(function (response) {
							console.log('/me/feed response: ' + JSON.stringify(response));
						})
						.fail(function (error) {
							console.log('/me/feed error: ' + JSON.stringify(err));
						});
					*/
					})
					.fail(function (err) {
					  console.log('Failed to connect to Facebook')
					});			
			}
			
		</script>		
	</head>
	<body>
			<div id="photoResutGroup">
				<img class="photoResut" src="thumbs/<?php echo $imagePath; ?>">
			</div>

			<div id="socialButtonGroup">
				<img class="socialButton" src="img/facebook.png" onclick="postFacebook()"></img>
				<img class="socialButton" src="img/google-logo.png" onclick="postGooglePlus()"></img>
				<img class="socialButton" src="img/instagram.png" onclick="postInstagram()"></img>
				<img class="socialButton" src="img/twitter.png" onclick="postTwitter()"></img>
				<img class="socialButton" src="img/emailbutton.jpg" onclick="postEmail()"></img>
			</div>
		</div>
		
		<div id="qrCodeGroup">
			<img class="qtCode" 
				src="https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=<?php echo $actual_link;?>&choe=UTF-8" 
				title="Votre photo" />
		</div>
	</body>	
</html>

