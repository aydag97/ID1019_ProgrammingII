defmodule Evaluation do

  @type literal() :: {:var, atom()} | {:num, number()} | {:q, literal(), literal()}

  @type expr() :: {:add, expr(), expr()}
            | {:sub, expr(), expr()}
            | {:mul, expr(), expr()}
            | {:div, expr(), expr()}
            | literal()

  ############## Evaluation ##############

  def eval({:num, n}, _) do {:num, n} end
  def eval({:q, n, m}, _) do
    if m == 0 do
      {:error, "Division by 0"}
    else
      simplify(n,m)
    end
  end
  def eval({:var, v}, map) do {:num, Map.get(map, v, nil)} end
  def eval({:add, e1, e2}, map) do add(eval(e1,map), eval(e2,map)) end
  def eval({:sub, e1, e2}, map) do sub(eval(e1,map), eval(e2,map)) end
  def eval({:mul, e1, e2}, map) do mul(eval(e1,map), eval(e2,map)) end
  def eval({:div, e1, e2}, map) do
    case eval(e2, map) do
      {:num, 0} -> {:error, "Division by 0"}
      _ -> divz(eval(e1, map), eval(e2, map))
    end
  end

  ############## Addition ##############

  def add({:num, n}, {:num, m}) do {:num, n+m} end
  def add({:num, n}, {:q, a, b}) do
  {:q, w = ((n*b) + a), b}
  simplify(w, b)
  end
  def add({:q, a, b}, {:num, n}) do
    {:q, w = (a + (n*b)), b}
    simplify(w, b)
  end
  def add({:q, a, b}, {:q, c, d}) do
    {:q, n = (a*d)+(c*b), m = (b*d)}
    simplify(n, m)
   end

  ############## Substraction ##############

  def sub({:num, n}, {:num, m}) do {:num, n - m} end
  def sub({:num, n}, {:q, a, b}) do
    {:q, w = ((n*b) - a), b}
    simplify(w, b)
  end
  def sub({:q, a, b}, {:num, n}) do
    {:q, w = (a - (n*b)), b}
    simplify(w, b)
  end
  def sub({:q, a, b}, {:q, c, d}) do
    {:q, n = (a*d)-(c*b), m = (b*d)}
    simplify(n, m)
  end

  ############## Multiplication ##############

  def mul({:num, n}, {:num, m}) do {:num, n * m} end
  def mul({:num, n}, {:q, a, b}) do
    {:q, w = (n*a), b}
    simplify(w, b)
  end
  def mul({:q, a, b}, {:num, n}) do
    {:q, w = (a*n), b}
    simplify(w, b)
  end
  def mul({:q, a, b}, {:q, c, d}) do
    {:q, n = (a*c), m = (b*d)}
    simplify(n, m)
  end

  ############## Division ##############

  def divz(_, {:num, 0}) do :error end
  def divz({:num, 0}, _ ) do {:num, 0} end
  def divz({:num, n}, {:q, a, b}) do
    {:q, w = n*b, a}
    simplify(w, a)
  end
  def divz({:q, a, b}, {:num, n}) do
    {:q, a, w = n*b}
    simplify(a, w)
  end
  def divz({:q, a, b}, {:q, c, d}) do
    {:q, n = a*d,m = b*c}
    simplify(n, m)
  end

  def divz({:num, n}, {:num, m}) do
    if rem(n, m) == 0 do
      {:num, floor(n/m)}
    else
      simplify(n,m)
    end
  end

############## Reduce & Simplify Functions ##############
  def gcd(n, 0) do n end
  def gcd(0, m) do m end
  def gcd(n, m) do gcd(m, rem(n,m)) end

  def simplify(n, m) do
    factor = gcd(n,m)
    {:q, floor(n/factor), floor(m/factor)}
  end

############## Print Functions ##############

  def print({:num, n}) do "#{n}" end
  def print({:var, v}) do "#{v}" end
  def print({:q, n, m}) do "#{n}/#{m}" end
  def print({:add, e1, e2}) do "#{print(e1)} + #{print(e2)}" end
  def print({:sub, e1, e2}) do "#{print(e1)} - #{print(e2)}" end
  def print({:mul, e1, e2}) do "(#{print(e1)}*#{print(e2)})" end
  def print({:div, e1, e2}) do "(#{print(e1)}) / (#{print(e2)})" end
  def print({:error, string}) do "Error, (#{string})" end


############## Test ##############

def test() do
  map = %{:x => 3, :y => 6, :z => 2, :w => 4, :r => 5}

  expr1 = {:div, {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:var, :r}}, {:q, 3, 11}}, {:num, 6}}
  ev1 = eval(expr1, map)

  expr2 = {:div, {:sub, {:q, 3, 4}, {:add, {:mul, {:q, 1, 4}, {:var, :y}}, {:num, 7}}}, {:num, 10}}
  ev2 = eval(expr2, map)

  expr3 = {:div, {:add, {:mul, {:num, 4}, {:var, :z}}, {:var, :w}}, {:num, 0}}
  ev3 = eval(expr3, map)

  IO.write("\nThe Environment: #{inspect(map)}\n")

  IO.write("\n-------- Test1 ----------\n")
  IO.write("The Expression: #{print(expr1)}\n")
  IO.write("The Result: #{print(ev1)}\n")

  IO.write("\n-------- Test2 ----------\n")
  IO.write("The Expression: #{print(expr2)}\n")
  IO.write("The Result: #{print(ev2)}\n")

  IO.write("\n-------- Test3 ----------\n")
  IO.write("The Expression: #{print(expr3)}\n")
  IO.write("The Result: #{print(ev3)}\n")
  end

end
