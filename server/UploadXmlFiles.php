<?php

	$folder1 = "client/assets/xml/";
	$folder2 = "dev/client/assets/xml/";
	
	$fileName = $_POST['fileName'];
	$data = $_POST['data'];

	function saveXml ($folder, $fileName, $data) {
		$path = $folder.$fileName;
		$fp = fopen ($path, 'w');
		$test = fwrite($fp, $data); // Запись в файл
		if ($test) {
			echo 'successful: '.$path;
		}
		else {
			echo 'UNSUCCESSFUL: '.$path;
		}
		fclose ($fp);
	}
	
	saveXml ($folder1, $fileName, $data);
	echo '; ';
	saveXml ($folder2, $fileName, $data);

?>