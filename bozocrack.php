<html>
<head>
<title>BozoCrackPHP Simply Scary Hash Cracker</title>
</head>
<body>
<h1>BozoCrackPHP Simply Scary Hash Cracker</h1>
<?

//Check if hashes have been submitted
if(isset($_POST['hashes'])){
  //If they have been, start processing them

  //Split input into array of hashes
  $hashes = explode("\n", $_POST['hashes']);

  $hashes = valid_hashes($hashes);

  $number_of_unique_hashes = count($hashes);
  echo "Loaded $number_of_unique_hashes unique hashes<br \>\n";

  //Begin cracking hashes
  foreach($hashes as $hash){
    //If cracking is successful, output the answer
    if($plaintext = crack_single_hash($hash)){
      echo "$hash:$plaintext<br />\n";
    }
  }
}

//Otherwise, only display the submission form

?>

<form action="bozocrack.php" method="post">
<textarea name="hashes" cols=40 rows=10></textarea><br />
<input type="submit" value="Submit Hashes" />
</form>

</body>
</html>
<?
//Functions

//valid_hashes(array $hashes) takes an array of hashes and returns only valid hashes
function valid_hashes(array $hashes){
  //Make sure the hashes are unique
  $hashes = array_unique($hashes);

  $valid_hashes = array();

  //start looping through hashes
  foreach($hashes as $hash){
    //Filter special chars
    $hash = preg_replace("/[^0-9a-zA-Z]/i", '', $hash);

    //Make sure hash is 32 characters
    if(strlen($hash) == 32){
      $valid_hashes[] = $hash;
    }
    //otherwise, warn the user
    else{
      echo "Warning: $hash is not 32 characters - MD5 hash must be 32 characters long.<br />\n";
    }
  }
  return $valid_hashes;
}

//crack_single_hash($hash) returns cracked hash or false
function crack_single_hash($hash){
  //search for the hash on Google
  $response = file_get_contents("http://www.google.com/search?q=$hash");

  //split Google's response into separate words
  $wordlist = preg_split("/\s+/", $response);

  //If hash can be cracked, return the answer
  if($plaintext = dictionary_attack($hash, $wordlist)){
    return $plaintext;
  }
  return false;
}

//dictionary_attack($hash, $wordlist) if it finds the cracked hash in the wordlist, it returns it
function dictionary_attack($hash, $wordlist){
  foreach($wordlist as $word){
    if(md5($word) == strtolower($hash)){
      return $word;
    }
  }
}
?>
