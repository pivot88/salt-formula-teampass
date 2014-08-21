<?php
global $lang, $txt, $k, $pathTeampas, $urlTeampass, $pwComplexity, $mngPages;
global $server, $user, $pass, $database, $pre, $db;

### DATABASE connexion parameters ###
$server = "{{ salt['pillar.get']('teampass:mysql:host', 'localhost') }}";
$user = "{{ salt['pillar.get']('teampass:mysql:user', 'teampass') }}";
$pass = "{{ salt['pillar.get']('teampass:mysql:pass') }}";
$database = "{{ salt['pillar.get']('teampass:mysql:db') }}";
$pre = "teampass_";

@date_default_timezone_set($_SESSION['settings']['timezone']);
@define('SECUREPATH', '/etc/teampass');
require_once "/etc/teampass/sk.php";
?>
