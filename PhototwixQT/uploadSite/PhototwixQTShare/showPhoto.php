<html>
	<head>
		<meta charset="utf-8" />
        <title>Phototwix</title>
		
		<link rel="stylesheet" type="text/css" href="css/mainstyle.css">
		<link rel="stylesheet" type="text/css" href="css/animate.css" />
		<link rel="stylesheet" type="text/css" href="css/flavr.css" />
		
		<script type="text/javascript" src="lib/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="lib/oauth.min.js"></script>
		<script type="text/javascript" src="lib/flavr.js"></script>
		
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

			$actual_link_base = "http://" . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'];
			if (strpos($actual_link_base, "&callback")) {
				$actual_link_base = strstr($actual_link_base, "&callback", true);
			}
			
			$actual_link = cut_string_using_last('/', $actual_link_base, 'left', true);
			$actual_link = $actual_link."photos/".$imagePath;
			$actual_link_encode = urlencode($actual_link);
			
			//Encode to base64
			
			$path = "photos/".$imagePath;
			$type = pathinfo($path, PATHINFO_EXTENSION);
			$data = file_get_contents($path);
			$base64 = 'data:image/' . $type . ';base64,' . base64_encode($data);

?>			
			var event_code = <?php echo "'$event_code'"; ?>
			
			var picUrl = "<?php echo $actual_link;?>"

			var redirectUrl = encodeURIComponent("<?php echo $actual_link_base; ?>")
			
			var facebook_message = "Test facebook"
			var twitter_message = "Test twitter"
			var google_message = "Test google"
			
			
			
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
			
			function enterEmail() {
				new $.flavr({
					content     : 'Votre email ?',
					dialog      : 'prompt',
					prompt      : { placeholder: 'email' },
					onConfirm   : function( $container, $prompt ){
						saveMail($prompt.val());
						sendMail($prompt.val());
					},
					onCancel    : function(){
						
					}
				});
			}
			
			function sendMail(mail) {
				console.log("Envoie d'un email" + mail);
				//TODO
				confirmSend();
			}
			
			function confirmSend() {
				new $.flavr({
					content     : 'La photo est envoyée !',
					autoclose   : true,
					timeout     : 2000  /* Default timeout is 3 seconds */
				});
			}
			
			function errorSend() {
				new $.flavr({
					content     : 'Une erreur est survenue !',
					autoclose   : true,
					timeout     : 2000  /* Default timeout is 3 seconds */
				});
			}
			
			function saveFacebook(res) {
				post_data = {
					'connection_type' 		: 'facebook',
					'connection_name'		: res.name,
					'connection_mail'		: res.email,
					'connection_gender'		: res.gender,
					'connection.birthday'	: res.birthday
				};
				console.log('Post Facebook: ' + JSON.stringify(post_data));
			}
			
			function saveTwitter(res) {
				post_data = {
					'connection_type' 		: 'twitter',
					'connection_name'		: res.name,
					'connection_mail'		: res.email,
					'connection_gender'		: res.gender,
					'connection.birthday'	: res.birthday
				};
				console.log('Post Twitter: ' + JSON.stringify(post_data));
			}			
			
			function saveGoogle(res) {
				post_data = {
					'connection_type' 		: 'twitter',
					'connection_name'		: res.name,
					'connection_mail'		: res.email,
					'connection_gender'		: res.gender,
					'connection.birthday'	: res.birthday
				};
				console.log('Post Google: ' + JSON.stringify(post_data));
			}
			
			function saveMail(res) {
				post_data = {
					'connection_type' 		: 'mail',
					'connection_mail'		: res
				};
				console.log('Post Mail: ' + JSON.stringify(post_data));
			}
			
			OAuth.initialize('3P-A917vxAg-qsXtHy4MtGjiH2Q');

			if ("" == callback_res) {
				OAuth.clearCache();
			}	
			
			if ("google_plus" == callback_res) {
				OAuth.callback('google_plus', {cache: false})
					.done(function(result) {
					  result.me()
						.done(function (response) {
							console.log('/me response: ' + JSON.stringify(response));
							saveGoogle(response);
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
							saveTwitter(response);
						})
						.fail(function (err) {
							console.log('/me error: ' + JSON.stringify(err));
						})
					  
					  /*
					  result.post('/1.1/statuses/update_with_media.json', {
						  'status' : twitter_message,
						  'media[]' : ['<?php echo $base64; ?>']
					  }).done(function (response) {
								confirmSend();
							})
							.fail(function (error) {
								console.log(JSON.stringify(error));
								errorSend() 
							});
						})
						.fail(function (error) {
							console.log(JSON.stringify(error));
							errorSend() 
						})
					  */

					  var url = 'http://media.giphy.com/media/Qw4X3FHCPlgDCDnMebe/giphy.gif'
					  var message = encodeURIComponent(twitter_message + ' ' + url);
					  result.post('1.1/statuses/update.json?status=' + message)
						.done(function (response) {
							confirmSend();
						})
						.fail(function (error) {
							console.log(JSON.stringify(err));
							errorSend() 
						});

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
							saveFacebook(response);
							confirmSend();
						})
						.fail(function (error) {
							console.log('/me error: ' + JSON.stringify(error));
							errorSend() 
						});	
						
						result.post('/me/feed', {
							data: {
								message: facebook_message,
								link: 'http://media.giphy.com/media/Qw4X3FHCPlgDCDnMebe/giphy.gif'//,
								//link: picUrl
							}
						})
						.done(function (response) {
							confirmSend();
						})
						.fail(function (error) {
							console.log('/me/feed error: ' + JSON.stringify(error));
							errorSend() 
						});
						
					})
					.fail(function (error) {
					  console.log('Failed to connect to Facebook');
					  errorSend();
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
				<!--img class="socialButton" src="img/google-logo.png" onclick="postGooglePlus()"></img-->
				<!--img class="socialButton" src="img/instagram.png" onclick="postInstagram()"></img-->
				<img class="socialButton" src="img/twitter.png" onclick="postTwitter()"></img>
				<img class="socialButton" src="img/emailbutton.jpg" onclick="enterEmail()"></img>
			</div>
		</div>
		
		<div id="qrCodeGroup">
			<img class="qtCode" 
				src="https://chart.googleapis.com/chart?chs=400x400&cht=qr&chl=<?php echo $actual_link;?>&choe=UTF-8" 
				title="Votre photo" />
		</div>
	</body>	
</html>

