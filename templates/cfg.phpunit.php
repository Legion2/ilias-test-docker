<?php

// Change these values to the user id, login and client id
// that should be used for testing
// after that, copy this file to
// Services/PHPUnit/config/cfg.phpunit.php
// After that, you can call phpunit from the ILIAS main directory with
// the local path of your test files.

$_SESSION["AccountId"] = '274';
$_POST["username"] = 'test';
$_GET["client_id"] = 'myilias';
