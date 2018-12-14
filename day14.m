1; # <- == :)

## you can't pass arguments by reference!
global recipes = [3 7 zeros(1, 10000)];
global p1 = 1;
global p2 = 2;
global n = 3;

function add_recipes (p1, p2)
  global recipes;
  global n;
  s = recipes(p1) + recipes(p2);
  if (s >= 10)
	recipes(n++) = mod(floor(s / 10), 10);
  end
  recipes(n++) = mod(s, 10);
endfunction

function p = next_pos (p)
  global recipes;
  global n;
  p = mod(p + recipes(p), n - 1) + 1; # no +1 because 1 indexed
endfunction

function iterate ()
  global recipes p1 p2;
  add_recipes(p1, p2);
  p1 = next_pos(p1, recipes);
  p2 = next_pos(p2, recipes);
endfunction

input = 110201;
part2_match = [1 1 0 2 0 1];

for i = 1:100000000
  last_n = n;
  iterate();
  ## if (n >= input + 11)
  ## 	p1 = sprintf("%d", recipes(n-10:n-1));
  ## 	printf("part1: %s\n", p1);
  ## 	break;
  ## endif
  if (n > 7)
  	for j = 0:(n - last_n - 1)
  	  if (all(recipes(n-6-j:n-j-1) == part2_match))
  		printf("part2: %d\n", n - 7 - j)
  	  endif
  	endfor
  endif
endfor
