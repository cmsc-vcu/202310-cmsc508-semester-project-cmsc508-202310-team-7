<html>
<head>
<title>Hello from PHP sample DB connection app</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script> 

$(document).ready(function(){
  $("#flip").click(function(){
    $("#panel").slideToggle("slow");
  });
});
</script>
<style> 
#panel, #flip {
  padding: 5px;
  text-align: center;
  background-color: #e5eecc;
  border: solid 1px #c3c3c3;
}

#panel {
  padding: 50px;
  display: none;
  text-align:left;
}
</style>
</head>
<body>
<h1>Team07 Moving Company</h1>
<p>
Team Members: Charles Cutler, Attard G
<p>
Sample connection to MySql using PHP 
<?php

# These setting are stored in the .htaccess file

$servername = $_SERVER['SAMPLE_SERVER'];
$username = $_SERVER['SAMPLE_USER'];
$password = $_SERVER['SAMPLE_PASS'];
$dbname = $_SERVER['SAMPLE_DB'];

echo "<br/>Database name: $dbname <br/>Username: $username<br/>";
try {
  $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
  // set the PDO error mode to exception
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  echo "<p/>Connection successful.";
} catch(PDOException $e) {
  echo "<p/>Connection failed: " . $e->getMessage();
}
?>
</p>

<div id="flip">Click to see acccessable Databases</div>
<div id="panel">
<h2>Databases that we can access</h2>
The following is a list of databases accessible by this
user account.<br/>
<table>
<?php
$dbs = $conn->query( 'SHOW DATABASES' );

while( ( $db = $dbs->fetchColumn( 0 ) ) !== false )
{
    echo "<tr><td>--></td><td>" . $db.'</td></tr>';
}
?>
</table>
</div>
<p style="text-align: center">
<button1 onclick="window.location.href='login.php'">Click to begin</button1>
</div>  
    </form>
</body>
</html>
