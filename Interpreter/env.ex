defmodule Env do

  def new() do [] end

  def add(id, str, []) do [{id,str}] end
  def add(id, str, env) do [{id,str}|remove(id,env)] end

  def lookup(_, []) do nil end
  def lookup(id, [{id, str}|_]) do {id, str} end
  def lookup(id, [_|tail]) do lookup(id, tail) end

  def remove(_, []) do [] end
  def remove(ids, [{ids,_}|tail]) do tail end
  def remove(ids, [head|tail]) do [head|remove(ids,tail)] end

  def closure([], env) do env end
  def closure([var|tail], env) do
    case lookup(var, env) do
      nil -> :error
      {_,_} -> closure(tail, env)
    end
  end

  def args([], _, env) do env end
  def args([param|params], [struct|structs], env) do
    args(params, structs, [{param, struct}|env])
  end

end
