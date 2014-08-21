<?php
@define('SALT', '{{ salt["pillar.get"]("teampass:saltkey", salt["grains.get_or_set_hash"]("teampass_salt_key", 30)) }}'); //Never Change it once it has been used !!!!!
@define('COST', '13'); // Don't change this.
?>
