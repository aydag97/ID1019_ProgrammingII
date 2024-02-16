defmodule Derivative do
  @type literal() :: {:num, number()}
                   | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
                | {:sub, expr(), expr()}
                | {:mul, expr(), expr()}
                | {:div, expr(), expr()}
                | {:exp, expr(), {:num, number()}}
                | {:ln, expr()}
                | {:sqrt, expr()}
                | {:sin, expr()}
                | {:cos, expr()}
                | literal()

  def test() do
  # test ={:add, {:mul, {:num, 4}, {:exp, {:var, :x}, {:num, 2}}},{:add, {:mul, {:num, 3}, {:var, :x}}, {:num, 42}}}
  # test = {:ln, {:exp, {:var, :x}, {:num, 2}}}
  # test = {:div, {:num, 1}, {:sin, {:mul, {:num, 2}, {:var, :x}}}}
  # test = {:sqrt, {:cos, {:var, :x}}}
  test = {:add,
  {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}},
         {:div, {:num, 1}, {:sqrt, {:exp, {:var, :x}, {:num, 3}}}}},
  {:mul, {:ln, {:cos, {:var, :x}}}, {:sin, {:add, {:num, 4}, {:exp, {:var, :x}, {:num, 3}}}}}}

  der = derive(test, :x)
  simpl = simplify(der)

  IO.write("expression: #{print(test)}\n")
  IO.write("derivative: #{print(der)}\n")
  IO.write("simplified: #{print(simpl)}\n")
  end
# Derivative rules
# derive/2 takes in 2 arguments: func (the function to be derivated), var (the variable of derivation)
  def derive(func, var) do
    case func do
      # d/dx c = 0
      {:num, _} -> {:num, 0}
      # d/dx x = 1
      {:var, ^var} -> {:num, 1}
      # d/dx y = 0
      {:var, _} -> {:num, 0}
      # d/dx f+g = d/dx f + d/dx g
      {:add, e1, e2} -> {:add, derive(e1,var), derive(e2,var)}
      # d/dx f-g = d/dx f - d/dx g
      {:sub, e1, e2} -> {:sub, derive(e1,var), derive(e2,var)}
      # d/dx f*g = (d/dx f) * g + f * (d/dx g)
      {:mul, e1, e2} -> {:add, {:mul, derive(e1, var), e2}, {:mul, e1, derive(e2, var)}}
      # d/dx f/g = ((d/dx f) * g - f * (d/dx g))/ g^2
      {:div, e1, e2} -> {:div, {:sub, {:mul, derive(e1, var), e2}, {:mul, e1, derive(e2, var)}}, {:exp, e2, {:num, 2}}}
      # d/dx f^n = n * (d/dx f) * f^(n-1)
      {:exp, e, {:num,n}} -> {:mul, {:mul, n, {:exp, e, {:num, n-1}}}, derive(e,var)}
      # d/dx ln(f) = (d/dx f)/ f
      {:ln, e} -> {:div, derive(e, var), e}
      # d/dx sqrt(f) = (d/dx f)/(2*sqrt(f))
      {:sqrt,e} -> {:div, derive(e, var), {:mul, {:num, 2}, {:sqrt, e}}}
      # d/dx sin(f) = (d/dx f) * cos(f)
      {:sin, e} -> {:mul, derive(e, var), {:cos, e}}
      # d/dx cos(f) = -(d/dx f) * sin(f)
      {:cos, e} -> {:mul, {:mul, {:num, -1}, derive(e, var)}, {:sin, e}}
    end
  end


  # Simplifications

  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:sub, e1, e2}) do simplify_sub(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:div, e1, e2}) do simplify_div(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end
  def simplify({:ln, e}) do simplify_ln(simplify(e)) end
  def simplify({:sqrt, e}) do simplify_sqrt(simplify(e)) end
  def simplify({:sin, e}) do simplify_sin(simplify(e)) end
  def simplify({:cos, e}) do simplify_cos(simplify(e)) end
  def simplify(e) do e end


  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add({:var, v}, {:var, v}) do {:mul, {:num, 2}, {:var, v}} end
  def simplify_add(e1, e2) do {:add, e1, e2} end


  def simplify_sub(e1,{:num, 0}) do e1 end
  def simplify_sub({:num, 0}, e2) do e2 end
  def simplify_sub({:num, n1},{:num, n2}) do {:num, n1-n2} end
  def simplify_sub(e1, e2) do {:sub, e1, e2} end

  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:var, v}, {:var, v}) do {:exp, {:var, v}, {:num, 2}} end
  def simplify_mul({:var, v}, {:exp, {:var, v}, {:num, n}}) do {:exp, {:var, v}, {:num, n+1}} end
  def simplify_mul({:exp, {:var, v}, {:num, n}}, {:var, v}) do {:exp, {:var, v}, {:num, n+1}} end
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e2}) do {:mul, {:num, n1*n2}, e2} end
  def simplify_mul({:num, n1}, {:mul, e2, {:num, n2}}) do {:mul, {:num, n1*n2}, e2} end
  def simplify_mul({:mul, {:num, n1}, e1}, {:num, n2}) do {:mul, {:num, n1*n2}, e1} end
  def simplify_mul({:mul, e1, {:num, n1}}, {:num, n2}) do {:mul, {:num, n1*n2}, e1} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end


  def simplify_div({:num, 0}, _) do {:num, 0} end
  def simplify_div(e, {:num, 1}) do e end
  def simplify_div({:num, 1}, {:num, 1}) do {:num, 1} end
  def simplify_div(e1, e2) do {:div, e1, e2} end


  def simplify_exp(_, {:num, 0}) do 1 end
  def simplify_exp(e, {:num, 1}) do e end
  def simplify_exp({:num, 1},_) do 1 end
  def simplify_exp({:num, 0},_) do 0 end
  def simplify_exp({:num, base}, {:num, n}) do {:num, :math.pow(base, n)} end
  def simplify_exp(e1,e2) do {:exp, e1, e2} end


  def simplify_ln({:num, 1}) do {:num, 0} end
  def simplify_ln(e1) do {:ln, e1} end


  def simplify_sqrt({:num,0}) do {:num, 0} end
  def simplify_sqrt({:num,1}) do {:num, 1} end
  def simplify_sqrt({:exp, e, {:num, 2}}) do e end
  def simplify_sqrt(e1) do {:sqrt, e1} end


  def simplify_sin({:num, 0}) do {:num, 0} end
  def simplify_sin({:num, 90}) do {:num, 1} end
  def simplify_sin({:num, 180}) do {:num, 0} end
  def simplify_sin({:num, 270}) do {:num, -1} end
  def simplify_sin({:num, 360}) do {:num, 0} end
  def simplify_sin(e1) do {:sin, e1} end

  def simplify_cos({:num, 0}) do {:num, 1} end
  def simplify_cos({:num, 90}) do {:num, 0} end
  def simplify_cos({:num, 180}) do {:num, -1} end
  def simplify_cos({:num, 270}) do {:num, 0} end
  def simplify_cos({:num, 360}) do {:num, 1} end
  def simplify_cos(e1) do {:cos, e1} end

  # print functions
  def print({:num, n}) do "#{n}" end
  def print({:var, v}) do "#{v}" end
  def print({:add, e1, e2}) do "#{print(e1)} + #{print(e2)}" end
  def print({:sub, e1, e2}) do "#{print(e1)} - #{print(e2)}" end
  def print({:mul, e1, e2}) do "#{print(e1)} * #{print(e2)}" end
  def print({:div, e1, e2}) do "#{print(e1)} / #{print(e2)}" end
  def print({:exp, e1, e2}) do "#{print(e1)} ^ (#{print(e2)})" end
  def print({:ln, e}) do "ln(#{print(e)})" end
  def print({:sqrt, e}) do "sqrt(#{print(e)})" end
  def print({:sin, e}) do "sin(#{print(e)})" end
  def print({:cos, e}) do "cos(#{print(e)})" end
  def print(e) do "#{e}" end

end
