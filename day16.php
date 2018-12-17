<?php

function create_sample($sample) {
    $lines = explode("\n", $sample);
    preg_match("/Before: \[([0-9, ]+)\]/", $lines[0], $bmatches);
    preg_match("/After:  \[([0-9, ]+)\]/", $lines[2], $amatches);
    return array(
        "b" => explode(", ", $bmatches[1]),
        "i" => explode(" ", $lines[1]),
        "a" => explode(", ", $amatches[1]),
    );
}

$input = file_get_contents("input/day16.txt");
$parts = explode("\n\n\n\n", $input);

$samples = explode("\n\n", $parts[0]);

$functions = array(
    "addr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] + $s["b"][$s["i"][2]];
        return $s["b"];
    },
    "addi" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] + $s["i"][2];
        return $s["b"];
    },
    "mulr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] * $s["b"][$s["i"][2]];
        return $s["b"];
    },
    "muli" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] * $s["i"][2];
        return $s["b"];
    },
    "banr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] & $s["b"][$s["i"][2]];
        return $s["b"];
    },
    "bani" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] & $s["i"][2];
        return $s["b"];
    },
    "borr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] | $s["b"][$s["i"][2]];
        return $s["b"];
    },
    "bori" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] | $s["i"][2];
        return $s["b"];
    },
    "setr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]];
        return $s["b"];
    },
    "seti" => function($s) {
        $s["b"][$s["i"][3]] = $s["i"][1];
        return $s["b"];
    },
    "gtir" => function($s) {
        $s["b"][$s["i"][3]] = $s["i"][1] > $s["b"][$s["i"][2]] ? "1" : "0";
        return $s["b"];
    },
    "gtri" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] > $s["i"][2]  ? "1" : "0";
        return $s["b"];
    },
    "gtrr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] > $s["b"][$s["i"][2]]  ? "1" : "0";
        return $s["b"];
    },
    "eqir" => function($s) {
        $s["b"][$s["i"][3]] = $s["i"][1] == $s["b"][$s["i"][2]] ? "1" : "0";
        return $s["b"];
    },
    "eqri" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] == $s["i"][2]  ? "1" : "0";
        return $s["b"];
    },
    "eqrr" => function($s) {
        $s["b"][$s["i"][3]] = $s["b"][$s["i"][1]] == $s["b"][$s["i"][2]]  ? "1" : "0";
        return $s["b"];
    },
);

$part1 = 0;
foreach($samples as $sample) {
    $s = create_sample($sample);
    $count = 0;
    foreach($functions as $name => $func) {
        if ($func($s) == $s["a"]) {
            $count++;
        }
    }
    if ($count >= 3) {
        $part1++;
    }
}
echo "$part1\n";

$opcodes = array();
while (count($opcodes) < 16) {
    foreach($samples as $sample) {
        $s = create_sample($sample);
        $instruction = $s["i"][0];
        $count = 0;
        if (in_array($instruction, $opcodes)) {
            continue;
        }
        foreach($functions as $name => $func) {
            if (!array_key_exists($name, $opcodes) && $func($s) == $s["a"]) {
                $count++;
                $last_name = $name;
            }
        }
        if ($count == 1) {
            $opcodes[$last_name] = $instruction;
        }
    }
}

$opcode_map = array_flip($opcodes);
$state = array(
    "b" => array(0, 0, 0, 0)
);

$instructions = explode("\n", $parts[1]);

foreach($instructions as $i) {
    if (!$i) break;
    $state["i"] = explode(" ", $i);
    $fi = $state["i"][0];
    $next = $functions[$opcode_map[$fi]]($state);
    $state["b"] = $next;
}

echo $state["b"][0] . "\n";

?>