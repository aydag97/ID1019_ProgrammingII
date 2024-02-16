
# <sequence> ::= <expression> | <match> ';' <expression>
# <match> ::= <pattern> '=' <expression>
# <expression> ::= <atom> | <variable> | '{' <expression> ',' <expression> '}'
# <pattern> ::= <atom> | <variable> | '_' | {' <pattern> ',' <pattern> '}'


defmodule Eager do

  def eval(seq) do eval_seq(seq, []) end

  def eval_expr({:atm, id}, _) do {:ok, id} end
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, str} -> {:ok, str}
    end
  end
  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error -> :error
      {:ok, hs} ->
        case eval_expr(tail, env) do
          :error -> :error
          {:ok, ts} -> {:ok, {hs, ts}}
        end
    end
  end

  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {_, struct} -> eval_cls(cls, struct, env)
    end
  end

  def eval_expr({:lambda, parameter, free, seq}, env) do
    case Env.closure(free, env) do
      :error -> :error
      closure -> {:ok, {:closure, parameter, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error -> :error
          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end

  def eval_expr({:fun, id}, _)  do
    {par, seq} = apply(Prgm, id, [])
    {:ok,  {:closure, par, seq, Env.new()}}
 end



  def eval_cls([], _, _) do :error end
  def eval_cls([{:clause, pattern, seq} | clauses], struct, env) do
    case eval_match(pattern, struct, eval_scope(pattern, env)) do
      # fails? continue with the rest of clauses
      :fail -> eval_cls(clauses, struct, env)
      # succeeds? evaluate the sequence of the clause
      {:ok, env} -> eval_seq(seq, env)
    end
  end


  def eval_args(args, env) do eval_args(args, env, []) end
  def eval_args([], _, structs) do {:ok, Enum.reverse(structs)} end
  def eval_args([arg|tail], env, structs) do
    case eval_expr(arg, env) do
      :error -> :error
      {:ok, strs} -> eval_args(tail, env, [strs|structs])
    end
  end


  def eval_match({:atm, id}, id, env) do {:ok, env} end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env)}
      {^id, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end
  def eval_match(:ignore, _, env) do {:ok, env} end
  def eval_match({:cons, pattern1, pattern2}, {struct1, struct2}, env) do
    case eval_match(pattern1, struct1, env) do
      :fail -> :fail
      {:ok, env} -> eval_match(pattern2, struct2, env)
    end
  end
  def eval_match(_, _, _) do :fail end


  def eval_scope(pattern, env) do
    Env.remove(extract_vars(pattern), env)
  end


  def extract_vars(pattern) do extract_vars(pattern, []) end
  def extract_vars({:var, var}, list) do [var | list] end
  def extract_vars({:cons, head, tail}, list) do
    extract_vars(tail, extract_vars(head,list))
  end
  def extract_vars(_, list) do list end


  def eval_seq([exp], env) do eval_expr(exp, env) end
  def eval_seq([{:match, pattern, expr} | seq], env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, str} -> new_env = eval_scope(pattern, env)
        case eval_match(pattern, str, new_env) do
          :fail -> :error
          {:ok, env} -> eval_seq(seq, env)
        end
    end
  end

end
