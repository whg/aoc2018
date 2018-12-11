program Day11;

const
   serial =  7803;

{ integer is 16 bits with fpc, WTF! }

function power(x, y : Int64) : Int64;
var
   rackId : integer;
begin
   rackId := x + 10;
   power := rackId * y + serial;
   power := power * rackId;
   power := power div 100 mod 10;
   power := power - 5;
end;


function square(x, y, size : Int64) : Int64;
var
   i, j	: Int64;
begin
   square := 0;
   size := size - 1;
   for i := 0 to size do
	  begin
		 for j := 0 to size do
			begin
			   square := square + power(x + i, y + j);
			end;
	  end;
end;

function maxSquare(size : Int64; var mx, my : Int64) : Int64;
var
   x, y, v : Int64;
begin
   maxSquare := 0;
   for x := 1 to 300 - size + 1 do
   	  begin
   		 for y := 1 to 300 - size + 1 do
   			begin
			   v := square(x, y, size);
			   if (v > maxSquare) then
				  begin
					 mx := x;
					 my := y;
					 maxSquare := v;
				  end;
   			end;
   	  end;
end;


var
   v, max, x, y, mx, my, ms, size : Int64;

begin
   maxSquare(3, x, y);
   writeln(x, ',', y);
   
   max := 0;
   for size := 1 to 30 do { they seem to go down after 30... }
	  begin
		 v := maxSquare(size, x, y);
		 if (v > max) then
			begin
			   mx := x;
			   my := y;
			   ms := size;
			   max := v;
			end;
	  end;
   writeln(mx, ',', my, ',', ms);
end.
