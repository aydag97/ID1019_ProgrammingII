defmodule Bench do

  def benchsprings(n) do
    Enum.reduce(1..n, 0, fn(n,p) ->
      {t, _} = :timer.tc(fn() -> Springs2.test(n) end)
    if p != 0 do
      :io.format(" n = ~w\t ~w us (~.2f)\n", [n, t, t/p])
      t
    else
      :io.format(" n = ~w\t ~w us \n", [n, t])
      t
      end
    end)
  end

end
