<?php
	$g_link = false;
	
	function GetMyConnection()
    {
		$sql_address = 'localhost';
		$sql_port = '3306';
		$sql_login = 'phototwix';
		$sql_password = 'totoro11';
		$sql_database = 'phototwix';
		
		
        global $g_link;
        if( $g_link )
            return $g_link;
        $g_link = new mysqli( $sql_address, $sql_login, $sql_password, $sql_database, $sql_port) or die('Could not connect to server.' );

		/*
		 * Utilisez cette syntaxe de $connect_error si vous devez assurer
		 * la compatibilité avec les versions de PHP avant 5.2.9 et 5.3.0.
		 */
		if (mysqli_connect_error()) {
			die('Erreur de connexion (' . mysqli_connect_errno() . ') '
					. mysqli_connect_error());
		}
		
        return $g_link;
    }
	
	function CleanUpDB()
    {
        global $g_link;
        if( $g_link != false )
            $g_link->close();
        $g_link = false;
    }
?>