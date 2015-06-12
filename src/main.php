<?php

$config = [
    "hosts" => [
        ["addr" => "aerospike", "port" => 3000]
    ]
];

$db = new Aerospike($config);

if (!$db->isConnected()) {
  echo "Failed to connect to the Aerospike server [{$db->errorno()}]: {$db->error()}\n";
  exit(1);
}

$begin = time();

for ($i = 0; $i < 100000; $i += 1) {
    $key = $db->initKey("test", "users", $i);

//    $db->remove($key, [
//        Aerospike::OPT_POLICY_KEY => Aerospike::POLICY_KEY_DIGEST
//    ]);
    $status = $db->put($key, ['v' => 12], -1, [ Aerospike::OPT_POLICY_KEY => Aerospike::POLICY_KEY_SEND ]);
    if ($status == Aerospike::OK) {
//        echo "Record written.\n";
    } else {
        echo "[{$db->errorno()}] ".$db->error();
    }

    if ($i % 50000 === 0) {
        var_dump($i);
    }
}

var_dump((time() - $begin) . 's');

//$count = 0;
//
//$db->scan("test", "users", function ($record) use ($db, &$count) {
//    $count += 1;
//}, [], [
//    Aerospike::OPT_SCAN_PERCENTAGE => 200
//]);
//
//var_dump($count);
